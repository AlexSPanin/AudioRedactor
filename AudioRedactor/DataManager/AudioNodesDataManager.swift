//
//  DataNodes.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import AVFAudio

class AudioNodesDataManager {
    
    static var shared = AudioNodesDataManager()
    
    private init() {}
    
    func getDataPlayingNodes() -> [AudioNodeModel] {
        let dataSongs = AudioDataManager.shared.fetchAudioData()
        var dataAudioNodes = [AudioNodeModel]()
        
        for dataSong in dataSongs {
            let dataNode = AudioNodeModel()
            dataNode.nodeForSong = dataSong
            dataAudioNodes.append(dataNode)
        }
        return dataAudioNodes
    }
}

