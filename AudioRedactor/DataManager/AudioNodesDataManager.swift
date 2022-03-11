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
        
        let audioData1 = AudioDataManager.shared.fetchAudioData(to: song1)
        let audioData2 = AudioDataManager.shared.fetchAudioData(to: song2)
        let audioData3 = AudioDataManager.shared.fetchAudioData(to: song3)
        
        var dataFrames1 = [AudioFrameModel]()
        var dataFrames2 = [AudioFrameModel]()
        
        let frame1 = AudioFrameDataManager.shared.getFrameDate(audio: audioData1, startInAudio: 5, length: 60, offset: 10)
        let frame2 = AudioFrameDataManager.shared.getFrameDate(audio: audioData2, startInAudio: 10, length: 30, offset: 5)
        let frame3 = AudioFrameDataManager.shared.getFrameDate(audio: audioData2, startInAudio: 5, length: 30, offset: 10)
        let frame4 = AudioFrameDataManager.shared.getFrameDate(audio: audioData3, startInAudio: 0, length: 160, offset: 5)
        
        dataFrames1.append(frame1)
        dataFrames1.append(frame2)
        dataFrames2.append(frame3)
        dataFrames2.append(frame4)
        
        
        var dataNodes = [AudioTrackModel]()
        
        dataNodes.append(AudioTrackDataManager.shared.getAudioTrackData(to: dataFrames1))
        dataNodes.append(AudioTrackDataManager.shared.getAudioTrackData(to: dataFrames2))
        
        return dataNodes
    }
}

