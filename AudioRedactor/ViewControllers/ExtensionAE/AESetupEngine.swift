//
//  AESetupEngine.swift
//  AudioEngine
//
//  Created by Александр Панин on 21.02.2022.
//

import UIKit

extension AudioEngineViewController {
    
    func clearIsEditing() {
        let count = dataPlayingNodes.count - 1
        for index in 0...count {
            dataPlayingNodes[index].isEditing = false
        }
    }
  
    func checkAddPlayer() {
       isActiveAddPlayer = dataPlayingNodes.contains { data in
            data.addPlayList
        }
    }
    
    func checkIsPlaying() -> Bool {
        dataPlayingNodes.contains { data in
            data.isPlaying
        }
    }
    
    func hiddenEffectView() {
        viewEffect.isHidden = true
        tableViewNode.reloadData()
    }
 
    
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




