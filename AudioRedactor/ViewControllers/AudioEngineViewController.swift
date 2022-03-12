//
//  AudioEngineViewController.swift
//  AudioEngine
//
//  Created by Александр Панин on 02.02.2022.
//

import UIKit
import AVFoundation

protocol AudioEngineViewControllerDelegate {
    func update (for index: String)
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
    var dataPlayingTracks = AudioTracksDataManager.shared.getDataPlayingTracks()
    
    // MARK: - number song and start button effect
    var activeEffectFrame: AudioFrameModel?
    var indexActiveFrame: String = ""
    var typeButtosEffect: ButtonsEffect = .volume
    
    // состояние плееров общее играют или нет
    var isPlaying: Bool = false
    
    // значения настроек слайдеров по песням
    var tracksSlidersValue = TrackSlidersValue.getTrackSlidersValue()
    
    // таймер привязанный к частоте обновления экрана
    var displayLink: CADisplayLink?
    
    // MARK: - User Interface
    var sizeTableView: CGSize = CGSize(width: 800, height: 400)
    var tableViewNode = UITableView()
    var scrollTableView = UIScrollView()
    
    var startedTimeStamp: CFTimeInterval = 0
    var endTimeStamp: CFTimeInterval = 0
   
    //MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        // init first active frame
        let startFrame = dataPlayingTracks.trackForTracks[0].framesForTrack[0]
        activeEffectFrame = startFrame
        indexActiveFrame = startFrame.index
        
        setupUI(frame: startFrame, type: typeButtosEffect)
        setupEffectValue()
        
        // prepare AudoiEngine
        configureEngine(dataPlayingTracks.trackForTracks)
        
        // prepare scrollview and table view wich track
        setupScrollTableView()
        
        // настройка таймера прерываний
        setupDisplayLink()
        
    }
    
    
    //MARK: - Подготовка аудио движка
    
    func configureEngine(_ dataNodes: [AudioTrackModel]) {
        configureAudioFrame()
        do {
            try audioEngine.start()
            
//            for dataNode in dataNodes {
//                scheduleAllAudioFileFramesForNode(to: dataNode)
//           }
        } catch {
            print("error configure Engine")
        }
    }
    
    // MARK: - create audio file and setting sign for ready play
    func scheduleAllAudioFileFramesForNode(to node: AudioTrackModel) {
        let frames = node.framesForTrack
        for frame in frames {
            scheduleAudioFileFrame(to: frame)
        }
    }
    
    func scheduleAudioFileFrame(to frame: AudioFrameModel) {
        let audioFile = frame.audioForFrame.file
        if frame.needsFileScheduledFrame {
            let frameCount = AVAudioFrameCount(frame.lengthFrame)
            frame.playerFrame.scheduleSegment(
                audioFile,
                startingFrame: frame.startFrameInAudio,
                frameCount: frameCount,
                at: nil)
        }
        frame.needsFileScheduledFrame.toggle()
        frame.isPlayerReadyFrame.toggle()
    }

    
    // MARK: -  запуск воспроизведения или пауза
    
    func playButton() {
        // проверка есть ли трэки в проекте
        if !dataPlayingTracks.trackForTracks.isEmpty {
            
            checkIsFinishPlaying()
            
            switch isPlaying {
            case true:
                
                for dataPlayingTrack in dataPlayingTracks.trackForTracks {
                    let frames = dataPlayingTrack.framesForTrack
                    for frame in frames {
                        frame.playerFrame.pause()
                        frame.isPlayingFrame = false
                    }
                }
                isPlaying.toggle()
                displayLink?.isPaused = true
                endTimeStamp += CACurrentMediaTime() - startedTimeStamp
                dataPlayingTracks.currentSecTime = endTimeStamp
                
            case false:
                
                for dataPlayingTrack in dataPlayingTracks.trackForTracks {
                    let frames = dataPlayingTrack.framesForTrack
                    for frame in frames {
                        if checkIsPlayFrame(frame: frame, currentTime: dataPlayingTracks.currentSecTime) {
                            if frame.needsFileScheduledFrame {scheduleAudioFileFrame(to: frame)}
                            frame.isPlayingFrame = true
                            frame.playerFrame.play()
                        }
                    }
                }
                isPlaying = checkIsPlayingFrame()
                displayLink?.isPaused = false
                startedTimeStamp = CACurrentMediaTime()
            }
        }
        tableViewNode.reloadData()
        changeImageButtonPlayPause(isPlaying)
    }
    
    func checkIsPlayFrame(frame: AudioFrameModel, currentTime: Double) -> Bool {
        let currentTime = currentTime
        let startTime = frame.startSecFrameInTracks
        let endTime = frame.lengthSecFrame + startTime
        let isPlaying: Bool = (currentTime < endTime && currentTime >= startTime)
        return isPlaying
    }
    
    func checkIsFinishPlaying() {
        
        let currentTime = dataPlayingTracks.currentSecTime
        let endTime = dataPlayingTracks.lengthSecTime
        
        
        
        if endTime <= currentTime {
            dataPlayingTracks.currentSecTime = 0
            isPlaying = false
            
            for dataTracks in dataPlayingTracks.trackForTracks {
                let frames = dataTracks.framesForTrack
                for frame in frames {
                    frame.currentSecFrame = 0
                    frame.currentFrame = 0
                    frame.isPlayingFrame = false
                    frame.needsFileScheduledFrame = true
                    frame.playerFrame.stop()
                }
            }
        }
    }
    
    
    
    @objc func updateDisplay() {
        
        for dataPlayingTrack in dataPlayingTracks.trackForTracks {
            
            let frames = dataPlayingTrack.framesForTrack
            
            for frame in frames {
                
                // проверка фрэйма на воспроизведение
                if frame.isPlayingFrame {
                    
                    // берем из узла последнее последнее время отработаное
                    guard let lastRenderTime = frame.playerFrame.lastRenderTime else { return }
                    
                    // преобразуем во время плеера
                    guard let playerTime = frame.playerFrame.playerTime(forNodeTime: lastRenderTime) else { return }
                    
                    // Время в виде нескольких аудиосэмплов, которые отслеживает текущее аудиоустройство.
                    
                    frame.currentFrame = playerTime.sampleTime + frame.seekFrame
                    frame.currentFrame = max(frame.currentFrame, 0)
                    frame.currentFrame = min(frame.currentFrame, AVAudioFramePosition(frame.lengthFrame))
                    frame.currentSecFrame = Double(frame.currentFrame) / frame.audioForFrame.audioSampleRate
                    
                    
                    // проверка если текущая позиция равна или больше изначальной длины аудифайла, то останавливаем и обнуляем узел
                    if frame.currentFrame >= frame.lengthFrame {
                        frame.playerFrame.stop()
                        frame.isPlayingFrame = false
                    }
                } else {
                    if checkIsPlayFrame(frame: frame, currentTime: dataPlayingTracks.currentSecTime) {
                        if frame.needsFileScheduledFrame { scheduleAudioFileFrame(to: frame)}
                        frame.playerFrame.play()
                        frame.isPlayingFrame = true
                        displayLink?.isPaused = false
                    }
                }
            }
        }
        let currentTimeStamp = CACurrentMediaTime()
        dataPlayingTracks.currentSecTime = currentTimeStamp - startedTimeStamp + endTimeStamp
        checkIsFinishPlaying()
        isPlaying = checkIsPlayingFrame()
        displayLink?.isPaused = !isPlaying
        tableViewNode.reloadData()
    }
    
    func seekButton(to time: Double) {
        
        for dataPlayingTrack in dataPlayingTracks.trackForTracks {
            let frames = dataPlayingTrack.framesForTrack
            for frame in frames {
                
                if frame.isPlayingFrame {
                    let offset = AVAudioFramePosition(time * frame.audioForFrame.audioSampleRate)
                    frame.seekFrame = frame.currentFrame + offset
                    frame.seekFrame = max(frame.seekFrame, 0)
                    frame.seekFrame = min(frame.seekFrame, AVAudioFramePosition(frame.lengthFrame))
                    frame.currentFrame = frame.seekFrame
                    
                    if frame.currentFrame < frame.lengthFrame {
                        updateDisplay()
                        let wasPlaying = frame.playerFrame.isPlaying
                        frame.playerFrame.stop()
                        frame.needsFileScheduledFrame = false
                        
                        let frameCount = frame.lengthFrame - AVAudioFrameCount(frame.seekFrame)
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
    
   
    
   
    
    
}
