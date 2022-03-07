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
    var activeEffectFrame: AudioFrameModel?
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
        
        let startFrame = dataPlayingNodes[0].framesForNode[0]
        activeEffectFrame = startFrame
        
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        setupUI(frame: startFrame, type: typeButtosEffect)
        
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
                scheduleAllAudioFileFramesForNode(to: dataNode)
            }
        } catch {
            print("error configure Engine")
        }
    }
    
        // MARK: - create audio file and setting sign for ready play
    func scheduleAllAudioFileFramesForNode(to node: AudioNodeModel) {
        let frames = node.framesForNode
        for frame in frames {
            scheduleAudioFileFrame(to: frame)
        }
        node.needsFileScheduledNode.toggle()
        node.isPlayerReadyNode.toggle()
    }
    
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
                    
                    let frames = dataPlayingNode.framesForNode
                    for frame in frames {
                        if frame.addPlayListFrame {
                        if frame.needsFileScheduledFrame { scheduleAudioFileFrame(to: frame)}
                        switch isPlaying {
                            
                        case true:
                            frame.playerFrame.pause()
                            frame.isPlayingFrame = false
                            displayLink?.isPaused = true
                            print("pause")
                        case false:
                            frame.playerFrame.play()
                            frame.isPlayingFrame = true
                            displayLink?.isPaused = false
                            print("play")
                        }
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
                let frames = dataPlayingNode.framesForNode
                for frame in frames {
                    let offset = AVAudioFramePosition(time * frame.audioForFrame.audioSampleRate)
                    frame.seekFrame = dataPlayingNode.currentFrameNode + offset
                    frame.seekFrame = max(frame.seekFrame, 0)
                    frame.seekFrame = min(frame.seekFrame, frame.audioForFrame.audioLengthSamples)
                    frame.currentFrame = frame.seekFrame
                    
                    if frame.currentFrame < frame.audioForFrame.audioLengthSamples {
                        updateDisplay()
                        let wasPlaying = frame.playerFrame.isPlaying
                        frame.playerFrame.stop()
                        frame.needsFileScheduledFrame = false
                        
                        let frameCount = AVAudioFrameCount(frame.audioForFrame.audioLengthSamples - frame.seekFrame)
                        frame.playerFrame.scheduleSegment(
                            frame.audioForFrame.file,
                            startingFrame: frame.seekFrame,
                            frameCount: frameCount,
                            at: nil
                        ) {
                            frame.needsFileScheduledFrame = true
                        }
                        if wasPlaying {
                            frame.playerFrame.play()
                        }
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
            let frames = dataPlayingNode.framesForNode
            for frame in frames {
                
                    // проверка ноды на воспроизведение
                    if frame.isPlayingFrame {
                        // берем из узла последнее последнее время отработаное
                        guard let lastRenderTime = frame.playerFrame.lastRenderTime else { return }
                        // преобразуем во время плеера
                        guard let playerTime = frame.playerFrame.playerTime(forNodeTime: lastRenderTime) else { return }
                        // Время в виде нескольких аудиосэмплов, которые отслеживает текущее аудиоустройство.
                //        dataPlayingNode.currentFrameNode = playerTime.sampleTime
                        frame.currentFrame = playerTime.sampleTime + frame.seekFrame
                        frame.currentFrame = max(frame.currentFrame, 0)
                        frame.currentFrame = min(frame.currentFrame, frame.audioForFrame.audioLengthSamples)
                        // проверка если текущая позиция равна или больше изначальной длины аудифайла, то останавливаем и обнуляем узел
                        if frame.currentFrame >= frame.audioForFrame.audioLengthSamples {
                            frame.playerFrame.stop()
                            frame.isPlayingFrame = false
                            
        //                    dataPlayingNode.seekFrame = 0
        //                    dataPlayingNode.currentFrame = 0
        //                    dataPlayingNode.addPlayList = false
        //                    dataPlayingNode.isPlayerReady = false
                        }
                        tableViewNode.reloadData()
                    }
                }
            }
        
        isPlaying = checkIsPlayingNodes()
        displayLink?.isPaused = !isPlaying
    }
    
    
}
