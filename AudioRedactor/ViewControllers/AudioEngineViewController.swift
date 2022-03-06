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
    var dataSongs = [AudioData]()
    var dataPlayingNodes = [DataAudioNode]()
    
    
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
        dataSongs = AudioDataManager.shared.fetchAudioData()
        dataPlayingNodes = DataAudioNodes.shared.getDataPlayingNodes()
        
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        setupUI(track: activeEffectNode, type: typeButtosEffect)
        
        setupEffectValue()
        configureEngine(dataSongs)
        
        self.tableViewNode.register(NodeTableViewCell.self, forCellReuseIdentifier: "nodeCell")
        self.tableViewNode.dataSource = self
        
        setupDisplayLink()
    }
    
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
    
    func configureEngine(_ dataSongs: [AudioData]) {
        // setting start value effect
        configureSetupEffect()
        
        // старт движка и монтирование аудифайлов
        do {
            try audioEngine.start()
            
            for dataPlayingNode in dataPlayingNodes {
                scheduleAudioFile(dataPlayingNode)
            }
        } catch {
            print("error configure Engine")
        }
    }
    
        // MARK: - create audio file and setting sign for ready play
    func scheduleAudioFile(_ node: DataAudioNode) {
        let audioNode = node
        let audioFile = audioNode.nodeForSong.file
        if audioNode.needsFileScheduled { audioNode.audioPlayerNode.scheduleFile(audioFile, at: nil) }
        audioNode.needsFileScheduled.toggle()
        audioNode.isPlayerReady.toggle()
    }
    
    // MARK: -  запуск воспроизведения или пауза
    
    func playButton() {
        
        if isActiveAddPlayer {
            
            for dataPlayingNode in dataPlayingNodes {
                if dataPlayingNode.addPlayList {
                    if dataPlayingNode.needsFileScheduled { scheduleAudioFile(dataPlayingNode)}
                    
                    switch isPlaying {
                        
                    case true:
                        dataPlayingNode.audioPlayerNode.pause()
                        dataPlayingNode.isPlaying = false
                        displayLink?.isPaused = true
                    case false:
                        dataPlayingNode.audioPlayerNode.play()
                        dataPlayingNode.isPlaying = true
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
            if dataPlayingNode.isPlaying {
                
                let offset = AVAudioFramePosition(time * dataPlayingNode.nodeForSong.audioSampleRate)
                dataPlayingNode.seekFrame = dataPlayingNode.currentPosition + offset
                dataPlayingNode.seekFrame = max(dataPlayingNode.seekFrame, 0)
                dataPlayingNode.seekFrame = min(dataPlayingNode.seekFrame, dataPlayingNode.nodeForSong.audioLengthSamples)
                dataPlayingNode.currentPosition = dataPlayingNode.seekFrame
                
                if dataPlayingNode.currentPosition < dataPlayingNode.nodeForSong.audioLengthSamples {
                    updateDisplay()
                    let wasPlaying = dataPlayingNode.audioPlayerNode.isPlaying
                    dataPlayingNode.audioPlayerNode.stop()
                    dataPlayingNode.needsFileScheduled = false
                    
                    let frameCount = AVAudioFrameCount(dataPlayingNode.nodeForSong.audioLengthSamples - dataPlayingNode.seekFrame)
                    dataPlayingNode.audioPlayerNode.scheduleSegment(
                        dataPlayingNode.nodeForSong.file,
                        startingFrame: dataPlayingNode.seekFrame,
                        frameCount: frameCount,
                        at: nil
                    ) {
                        dataPlayingNode.needsFileScheduled = true
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
            if dataPlayingNode.isPlaying {
                // берем из узла последнее последнее время отработаное
                guard let lastRenderTime = dataPlayingNode.audioPlayerNode.lastRenderTime else { return }
                // преобразуем во время плеера
                guard let playerTime = dataPlayingNode.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) else { return }
                // Время в виде нескольких аудиосэмплов, которые отслеживает текущее аудиоустройство.
                dataPlayingNode.currentFrame = playerTime.sampleTime
                dataPlayingNode.currentPosition = dataPlayingNode.currentFrame + dataPlayingNode.seekFrame
                dataPlayingNode.currentPosition = max(dataPlayingNode.currentPosition, 0)
                dataPlayingNode.currentPosition = min(dataPlayingNode.currentPosition, dataPlayingNode.nodeForSong.audioLengthSamples)
                // проверка если текущая позиция равна или больше изначальной длины аудифайла, то останавливаем и обнуляем узел
                if dataPlayingNode.currentPosition >= dataPlayingNode.nodeForSong.audioLengthSamples {
                    dataPlayingNode.audioPlayerNode.stop()
                    dataPlayingNode.isPlaying = false
                    
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
