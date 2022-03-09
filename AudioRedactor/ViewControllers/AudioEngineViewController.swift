//
//  AudioEngineViewController.swift
//  AudioEngine
//
//  Created by Александр Панин on 02.02.2022.
//

import UIKit
import AVFoundation

protocol NodeTableViewCellDelegate {
    func button (for index: String)
 //   func addSwitch ( for cell: NodeTableViewCell)
}

class AudioEngineViewController: UIViewController {
    
   
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
    var dataPlayingNodes = [AudioNodeModel]()
    
    
    // MARK: - number song and start button effect
    var activeEffectFrame: AudioFrameModel?
    var typeButtosEffect: ButtonsEffect = .volume
   
    // состояние плееров общее играют или нет
    var isPlaying: Bool = false
    
    // значения настроек слайдеров по песням
    var tracksSlidersValue = TrackSlidersValue.getTrackSlidersValue()
    
    
    private var displayLink: CADisplayLink?
    var timer: Timer?
    
    // MARK: - User Interface
    var sizeTableView: CGSize = CGSize(width: 800, height: 400)
    var tableViewNode = UITableView()
    var scrollTableView = UIScrollView()
    
   
    
    //MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        // get data for AudioEngine
        dataPlayingNodes = AudioNodesDataManager.shared.getDataPlayingNodes()
        
        // init first active frame
        let startFrame = dataPlayingNodes[0].framesForNode[0]
        activeEffectFrame = startFrame
        
        setupUI(frame: startFrame, type: typeButtosEffect)
        setupEffectValue()
        
        // prepare AudoiEngine
        configureEngine(dataPlayingNodes)
        
        // prepare scrollview and table view wich track
        setupScrollTableView()
        
        // настройка таймера прерываний
        setupDisplayLink()
        
    }
    
    func setWidthContext() -> CGFloat {
        var width: CGFloat = view.bounds.width
        for dataPlayingNode in dataPlayingNodes {
            if width < CGFloat(dataPlayingNode.lengthSecondsNode) * 5 { width = CGFloat(dataPlayingNode.lengthSecondsNode * 5) }
        }
        return width
    }
    
    func setHeightContext() -> CGFloat {

        return view.bounds.height - 270
    }
    
    
  
    func setupScrollTableView() {
        
        sizeTableView = CGSize(
            width: setWidthContext(),
            height: setHeightContext()
        )
        
        scrollTableView.contentSize = sizeTableView
        scrollTableView.showsVerticalScrollIndicator = false
        scrollTableView.isScrollEnabled = true
        scrollTableView.showsLargeContentViewer = true
        scrollTableView.bounces = false

        self.view.addSubview(scrollTableView)

        scrollTableView.translatesAutoresizingMaskIntoConstraints = false
        scrollTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -270).isActive = true
        scrollTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        tableViewNode.register(NodeTableViewCell.self, forCellReuseIdentifier: "nodeCell")
        tableViewNode.dataSource = self
        scrollTableView.showsVerticalScrollIndicator = false
        tableViewNode.bounces = false
        tableViewNode.rowHeight = 80
        
        

        self.scrollTableView.addSubview(tableViewNode)
        
        tableViewNode.translatesAutoresizingMaskIntoConstraints = false
        tableViewNode.topAnchor.constraint(equalTo: scrollTableView.topAnchor).isActive = true
        tableViewNode.leftAnchor.constraint(equalTo: scrollTableView.leftAnchor).isActive = true
        tableViewNode.rightAnchor.constraint(equalTo: scrollTableView.rightAnchor).isActive = true
        tableViewNode.bottomAnchor.constraint(equalTo: scrollTableView.bottomAnchor).isActive = true
        
        tableViewNode.widthAnchor.constraint(equalToConstant: sizeTableView.width).isActive = true
        tableViewNode.heightAnchor.constraint(equalToConstant: sizeTableView.height).isActive = true


    }
    
    //MARK: - Подготовка аудио движка
    
    func configureEngine(_ dataNodes: [AudioNodeModel]) {
        configureAudioFrame()
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
        
        if !dataPlayingNodes.isEmpty {
            for dataPlayingNode in dataPlayingNodes {
                    
                    let frames = dataPlayingNode.framesForNode
                    for frame in frames {
                      
                        if frame.needsFileScheduledFrame { scheduleAudioFileFrame(to: frame)}
                        switch isPlaying {
                            
                        case true:
                            frame.playerFrame.pause()
                            frame.isPlayingFrame = false
                           displayLink?.isPaused = true
 
                        case false:
                           
                            frame.playerFrame.play()
                            frame.isPlayingFrame = true
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
            let frames = dataPlayingNode.framesForNode
            for frame in frames {
                if frame.isPlayingFrame {
                    let offset = AVAudioFramePosition(time * frame.audioForFrame.audioSampleRate)
                    frame.seekFrame = frame.currentFrame + offset
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
        displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 15, maximum: 30, preferred: 15) // частота обновления экрана с секунду
        displayLink?.isPaused = true
    }
    
    @objc func updateDisplay() {
       
        for dataPlayingNode in dataPlayingNodes {
            let frames = dataPlayingNode.framesForNode
            for frame in frames {
                    // проверка фрэйма на воспроизведение
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
                        }
                    }
                }
            }

        tableViewNode.reloadData()
        isPlaying = checkIsPlayingNodes()
        displayLink?.isPaused = !isPlaying
        
    }
    
    
}
