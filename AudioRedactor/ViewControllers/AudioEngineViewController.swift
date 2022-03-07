//
//  AudioEngineViewController.swift
//  AudioEngine
//
//  Created by Александр Панин on 02.02.2022.
//

import UIKit
import AVFoundation

protocol NodeTableViewCellDelegate {
    func button (for cell: NodeTableViewCell)
    func addSwitch ( for cell: NodeTableViewCell)
}

class AudioEngineViewController: UIViewController {
    
    // MARK: - User Interface
    
    weak var tableViewNode: UITableView!
    
    // Player View
    var buttonsPlayer: [UIButton] = []
    var stackPlayer = UIStackView()
    
    // Editor View
    let viewEditor = UIView()
    var buttonsEditor: [UIButton] = []
    var stackEditor = UIStackView()
    
    
    // MARK: - Effect View
    // Effect View
    let viewEffect = UIView()
    var stackEffect = UIStackView()
    
    // Effect Buttons
    var buttonsEffect: [UIButton] = []
    var labelsEffect: [UILabel] = []
    var stackEffectButton = UIStackView()
    var stackEffectLabel = UIStackView()
    
    //Effect Sliders
    var slidersEffect = UISlider()
    var slidersTextEffect: [UILabel] = []
    var slidersImageEffect: [UIImageView] = []
    var stackEffectSlider = UIStackView()
    var stackEffectText = UIStackView()
    var stackEffectImage = UIStackView()
    
    // MARK: - AudioEngine
    // Mixer and Engine
    var audioFile: AVAudioFile?
    let audioEngine = AVAudioEngine()
    let audioMixer = AVAudioMixerNode()
    let micMixer = AVAudioMixerNode()
    
    // MARK: - Data Songs and Settings UI and start value
    var setting = Setting.getSetting()
//    var dataSongs = [AudioDataModel]()
    var dataPlayingNodes = [AudioNodeModel]()
    
    
    // MARK: - number song and start button effect
    var activeEffectNode: Int = 0
    var isActiveAddPlayer: Bool = false
    var typeButtosEffect: ButtonsEffect = .volume
   
    // состояние плееров общее играют или нет
    var isPlaying: Bool = false
    
    // значения настроек слайдеров по песням
    var tracksSlidersValue = TrackSlidersValue.getTrackSlidersValue()
    
    
    private var displayLink: CADisplayLink?
    
//MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
//        let songs = SongsDataManager.shared.fetchSongs()
//        for song in songs {
//            dataSongs.append(AudioDataManager.shared.fetchAudioData(to: song))
//        }
        
        dataPlayingNodes = AudioNodesDataManager.shared.getDataPlayingNodes()
        
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        setupUI(track: activeEffectNode, type: typeButtosEffect)
        
        setupEffectValue()
        configureEngine(dataPlayingNodes)
        
        self.tableViewNode.register(NodeTableViewCell.self, forCellReuseIdentifier: "nodeCell")
        self.tableViewNode.dataSource = self
        
        setupDisplayLink()
    }
    
    // MARK: -  create table view for audio nodes
    override func loadView() {
        super.loadView()
        
        let tableView = UITableView()
        tableView.rowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        
        self.tableViewNode = tableView
    }
    
    //MARK: - Подготовка аудио движка
    
    func configureEngine(_ dataNodes: [AudioNodeModel]) {
        audioEngine.attach(audioMixer)
        audioEngine.attach(micMixer)
        
        // setting start value effect
        for dataNode in dataNodes {
            let frames = dataNode.framesForNode
            for frame in frames {
                configureAudioFrame(to: frame)
            }
        }
        // старт движка и монтирование аудифайлов
        do {
            try audioEngine.start()
            
            for dataNode in dataNodes {
                let frames = dataNode.framesForNode
                for frame in frames {
                    scheduleAudioFileFrame(to: frame)
                }
            }
        } catch {
            print("error configure Engine")
        }
    }
    
        // MARK: - create audio file and setting sign for ready play
    func scheduleAudioFileFrame(to frame: AudioFrameModel) {
        let audioFile = frame.audioForFrame.file
        if frame.needsFileScheduledFrame { frame.playerFrame.scheduleFile(audioFile, at: nil) }
        frame.needsFileScheduledFrame.toggle()
        frame.isPlayerReadyFrame.toggle()
    }
    
    // MARK: -  запуск воспроизведения или пауза
    
    func playButton() {
        
        if isActiveAddPlayer {
            
            for dataPlayingNode in dataPlayingNodes {
                if dataPlayingNode.addPlayListNode {
                    if dataPlayingNode.needsFileScheduledNode { scheduleAudioFileFrame(dataPlayingNode)}
                    
                    switch isPlaying {
                        
                    case true:
                        dataPlayingNode.audioPlayerNode.pause()
                        dataPlayingNode.isPlayingNode = false
                        displayLink?.isPaused = true
                    case false:
                        dataPlayingNode.audioPlayerNode.play()
                        dataPlayingNode.isPlayingNode = true
                        displayLink?.isPaused = false
                    }
                }
            }
            isPlaying.toggle()
            changeImageButtonPlayPause(isPlaying)
            tableViewNode.reloadData()
        }
    }

    func seekButton(to time: Double) {
        
        for dataPlayingNode in dataPlayingNodes {
            if dataPlayingNode.isPlayingNode {
                
                let offset = AVAudioFramePosition(time * dataPlayingNode.nodeForSong.audioSampleRate)
                dataPlayingNode.seekFrameNode = dataPlayingNode.currentFrameNode + offset
                dataPlayingNode.seekFrameNode = max(dataPlayingNode.seekFrameNode, 0)
                dataPlayingNode.seekFrameNode = min(dataPlayingNode.seekFrameNode, dataPlayingNode.nodeForSong.audioLengthSamples)
                dataPlayingNode.currentFrameNode = dataPlayingNode.seekFrameNode
                
                if dataPlayingNode.currentFrameNode < dataPlayingNode.nodeForSong.audioLengthSamples {
                    updateDisplay()
                    let wasPlaying = dataPlayingNode.audioPlayerNode.isPlaying
                    dataPlayingNode.audioPlayerNode.stop()
                    dataPlayingNode.needsFileScheduledNode = false
                    
                    let frameCount = AVAudioFrameCount(dataPlayingNode.nodeForSong.audioLengthSamples - dataPlayingNode.seekFrameNode)
                    dataPlayingNode.audioPlayerNode.scheduleSegment(
                        dataPlayingNode.nodeForSong.file,
                        startingFrame: dataPlayingNode.seekFrameNode,
                        frameCount: frameCount,
                        at: nil
                    ) {
                        dataPlayingNode.needsFileScheduledNode = true
                    }
                    if wasPlaying {
                        dataPlayingNode.audioPlayerNode.play()
                    }
                }
            }
        }
    }
    
    func setupDisplayLink() {
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateDisplay))
        displayLink?.add(to: .current, forMode: .default)
        displayLink?.isPaused = true
    }
    
    @objc func updateDisplay() {
        
        for dataPlayingNode in dataPlayingNodes {
            // проверка ноды на воспроизведение
            if dataPlayingNode.isPlayingNode {
                // берем из узла последнее последнее время отработаное
                guard let lastRenderTime = dataPlayingNode.audioPlayerNode.lastRenderTime else { return }
                // преобразуем во время плеера
                guard let playerTime = dataPlayingNode.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) else { return }
                // Время в виде нескольких аудиосэмплов, которые отслеживает текущее аудиоустройство.
        //        dataPlayingNode.currentFrameNode = playerTime.sampleTime
                dataPlayingNode.currentFrameNode = playerTime.sampleTime + dataPlayingNode.seekFrameNode
                dataPlayingNode.currentFrameNode = max(dataPlayingNode.currentFrameNode, 0)
                dataPlayingNode.currentFrameNode = min(dataPlayingNode.currentFrameNode, dataPlayingNode.nodeForSong.audioLengthSamples)
                // проверка если текущая позиция равна или больше изначальной длины аудифайла, то останавливаем и обнуляем узел
                if dataPlayingNode.currentFrameNode >= dataPlayingNode.nodeForSong.audioLengthSamples {
                    dataPlayingNode.audioPlayerNode.stop()
                    dataPlayingNode.isPlayingNode = false
                    
//                    dataPlayingNode.seekFrame = 0
//                    dataPlayingNode.currentFrame = 0
//                    dataPlayingNode.addPlayList = false
//                    dataPlayingNode.isPlayerReady = false
                }
                tableViewNode.reloadData()
            }
        }
        isPlaying = checkIsPlaying()
        displayLink?.isPaused = !isPlaying
    }
    
    
}
