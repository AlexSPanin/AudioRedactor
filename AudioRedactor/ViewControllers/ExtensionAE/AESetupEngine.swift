//
//  AESetupEngine.swift
//  AudioEngine
//
//  Created by Александр Панин on 21.02.2022.
//

import UIKit

extension AudioEngineViewController {
 
    
    //MARK: -  первоначальные настройки эффектов по 3 нодам
    
    func configureSetupEffect() {
        
        audioEngine.attach(audioMixer)
        audioEngine.attach(micMixer)
        
        for dataPlayingNode in dataPlayingNodes {
            let bands = dataPlayingNode.equalizer.bands
            bands[0].frequency = 0
            bands[0].filterType = .highPass
            bands[0].bypass = false
            dataPlayingNode.delayEcho.delayTime = 0
            dataPlayingNode.reverb.loadFactoryPreset(.largeHall)
            
            audioEngine.attach(dataPlayingNode.audioPlayerNode)
            audioEngine.attach(dataPlayingNode.delayEcho)
            audioEngine.attach(dataPlayingNode.reverb)
            audioEngine.attach(dataPlayingNode.equalizer)
            
            let format = dataPlayingNode.nodeForSong.audioFormat
            let freeBus = audioEngine.mainMixerNode.nextAvailableInputBus

            audioEngine.connect(dataPlayingNode.audioPlayerNode, to: dataPlayingNode.delayEcho, format: format)
            audioEngine.connect(dataPlayingNode.delayEcho, to: dataPlayingNode.reverb, format: format)
            audioEngine.connect(dataPlayingNode.reverb, to: dataPlayingNode.equalizer, format: format)
            audioEngine.connect(dataPlayingNode.equalizer, to: audioEngine.mainMixerNode, fromBus: 0, toBus: freeBus, format: format)
            
            audioEngine.prepare()
            
        }
    }
}




