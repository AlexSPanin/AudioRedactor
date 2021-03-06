//
//  AESetupEngine.swift
//  AudioEngine
//
//  Created by Александр Панин on 21.02.2022.
//

import UIKit

extension AudioEngineViewController {
    
    //MARK: -  первоначальные настройки эффектов по фрэйму
    
    func configureAudioFrame() {
        let dataPlayingTracks = dataPlayingTracks.trackForTracks
        audioEngine.attach(audioMixer)
        audioEngine.attach(micMixer)
        for dataPlayingTrack in dataPlayingTracks {
            let frames = dataPlayingTrack.framesForTrack
            for frame in frames {
                
                let bands = frame.equalizerFrame.bands
                bands[0].frequency = frame.effectFrame.eqHight
                bands[0].filterType = .highPass
                bands[0].bypass = false
                bands[1].frequency = frame.effectFrame.eqLow
                bands[1].filterType = .lowPass
                bands[1].bypass = false
                frame.delayEchoFrame.delayTime = TimeInterval(frame.effectFrame.delay)
                frame.reverbFrame.loadFactoryPreset(.largeHall)
                
                audioEngine.attach(frame.playerFrame)
                audioEngine.attach(frame.delayEchoFrame)
                audioEngine.attach(frame.reverbFrame)
                audioEngine.attach(frame.equalizerFrame)
                
                let format = frame.audioForFrame.audioFormat
                let freeBus = audioEngine.mainMixerNode.nextAvailableInputBus
                
                audioEngine.connect(frame.playerFrame, to: frame.delayEchoFrame, format: format)
                audioEngine.connect(frame.delayEchoFrame, to: frame.reverbFrame, format: format)
                audioEngine.connect(frame.reverbFrame, to: frame.equalizerFrame, format: format)
                audioEngine.connect(frame.equalizerFrame, to: audioEngine.mainMixerNode, fromBus: 0, toBus: freeBus, format: format)
            }
        }
        audioEngine.prepare()
    }
    // MARK: - настройка таймера обновления экрана
    func setupDisplayLink() {
        

        displayLink = CADisplayLink(target: self, selector: #selector(updateDisplay))  // возможно надо заменить на простой таймер для синхронизации всего аудио трэка
        displayLink?.add(to: .current, forMode: .default)
        displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 2, maximum: 2, __preferred: 2) // частота обновления экрана с секунду
        displayLink?.isPaused = true
    }
        
    // отчистка признака редактирования у всех фрэймов
    func clearIsEditingFrames() {
        let dataPlayingTracks = dataPlayingTracks.trackForTracks
        for dataPlayingTrack in dataPlayingTracks {
            let frames = dataPlayingTrack.framesForTrack
            for frame in frames {
                frame.isEditingFrame = false
            }
        }
    }
    // проверка готовности фрэймов к воспроизведению
    func checkIsPlayingFrame() -> Bool {
        var isPlaing = false
        let dataPlayingTracks = dataPlayingTracks.trackForTracks
        for dataPlaingTrack in dataPlayingTracks {
            isPlaing = dataPlaingTrack.framesForTrack.contains { frame in
                frame.isPlayingFrame
            }
            if isPlaing { return isPlaing}
        }
        return isPlaing
    }
    
   
    
}






