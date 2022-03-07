//
//  AESetupEngine.swift
//  AudioEngine
//
//  Created by Александр Панин on 21.02.2022.
//

import UIKit

extension AudioEngineViewController {
    
    func clearIsEditingFrame() {
        let dataPlayingNodes = dataPlayingNodes
        for dataPlayingNode in dataPlayingNodes {
            let frames = dataPlayingNode.framesForNode
            for frame in frames {
                frame.isEditingFrame = false
            }
        }
    }
  
    func checkAddPlayer() {
       isActiveAddPlayer = dataPlayingNodes.contains { data in
            data.addPlayListNode
        }
    }
    
    func checkIsPlaying() -> Bool {
        dataPlayingNodes.contains { data in
            data.isPlayingNode
        }
    }
    
    func hiddenEffectView() {
        viewEffect.isHidden = true
        tableViewNode.reloadData()
    }
    
    
    
    //MARK: -  первоначальные настройки эффектов по фрэйму
    
    func configureAudioFrame(to frame: AudioFrameModel) {
        
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
        
        audioEngine.prepare()
    }
}






