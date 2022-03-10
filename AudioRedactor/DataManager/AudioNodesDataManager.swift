//
//  DataNodes.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

//MARK: - настройка какие фреймы привязываю к трэкам

import AVFAudio

class AudioNodesDataManager {
    static var shared = AudioNodesDataManager()
    private init() {}
    
    func getDataPlayingNodes() -> [AudioTrackModel] {
        let songs = SongsDataManager.shared.fetchSongs()
        let song1 = songs[0]
        let song2 = songs[1]
        let song3 = songs[2]
        
        var dataNodes = [AudioTrackModel]()
        var dataFrames1 = [AudioFrameModel]()
        var dataFrames2 = [AudioFrameModel]()
        
        dataFrames1.append(AudioFrameDataManager.shared.getFrameDate(to: AudioDataManager.shared.fetchAudioData(to: song2)))
    // dataFrames1.append(AudioFrameDataManager.shared.getFrameDate(to: AudioDataManager.shared.fetchAudioData(to: song1)))
        dataFrames2.append(AudioFrameDataManager.shared.getFrameDate(to: AudioDataManager.shared.fetchAudioData(to: song3)))
        
       dataNodes.append(AudioTrackDataManager.shared.getAudioTrackData(to: dataFrames1))
       dataNodes.append(AudioTrackDataManager.shared.getAudioTrackData(to: dataFrames2))
      
        return dataNodes
    }
}

