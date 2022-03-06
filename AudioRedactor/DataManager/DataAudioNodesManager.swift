//
//  DataNodes.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import Foundation
import AVFAudio

class DataAudioNodes {
    
    static var shared = DataAudioNodes()
    
    private init() {}
    
    func getDataPlayingNodes() -> [DataAudioNode] {
        let dataSongs = AudioDataManager.shared.fetchAudioData()
        var dataAudioNodes = [DataAudioNode]()
        
        for dataSong in dataSongs {
            let dataNode = DataAudioNode()
            dataNode.nodeForSong = dataSong
            dataAudioNodes.append(dataNode)
        }
        return dataAudioNodes
    }
}

