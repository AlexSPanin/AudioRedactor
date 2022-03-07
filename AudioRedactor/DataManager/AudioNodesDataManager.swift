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
        let songs = SongsDataManager.shared.fetchSongs()
        var dataNodes = [AudioNodeModel]()
        for song in songs {
            var dataFrames = [AudioFrameModel]()
            let audioData = AudioDataManager.shared.fetchAudioData(to: song)
            dataFrames.append(AudioFrameDataManager.shared.getFrameDate(to: audioData))
            let audioNode = AudioNodeDataManager.shared.getAudioNodeData(to: dataFrames)
            dataNodes.append(audioNode)
        }
        return dataNodes
    }
}

