//
//  DataNodes.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

//MARK: - настройка какие фреймы привязываю к трэкам и с какими парраметрами

import AVFAudio

class AudioTracksDataManager {
    static var shared = AudioTracksDataManager()
    private init() {}
    
    func getDataPlayingTracks() -> AudioTracksModel {
        let songs = SongsDataManager.shared.fetchSongs()
        let song1 = songs[0]
        let song2 = songs[1]
        let song3 = songs[2]
        
        let audioData1 = AudioDataManager.shared.fetchAudioData(to: song1)
        let audioData2 = AudioDataManager.shared.fetchAudioData(to: song2)
        let audioData3 = AudioDataManager.shared.fetchAudioData(to: song3)
        
        var dataFrames1 = [AudioFrameModel]()
        var dataFrames2 = [AudioFrameModel]()
        var dataFrames3 = [AudioFrameModel]()
        
        let frame1 = AudioFrameDataManager.shared.getFrameDate(audio: audioData1, startInAudio: 15, length: 15, offset: 0)
        let frame2 = AudioFrameDataManager.shared.getFrameDate(audio: audioData2, startInAudio: 10, length: 30, offset: 10)
        let frame3 = AudioFrameDataManager.shared.getFrameDate(audio: audioData2, startInAudio: 20, length: 30, offset: 0)
        let frame4 = AudioFrameDataManager.shared.getFrameDate(audio: audioData3, startInAudio: 150, length: 40, offset: 10)
        let frame5 = AudioFrameDataManager.shared.getFrameDate(audio: audioData2, startInAudio: 0, length: 60, offset: 10)
        let frame6 = AudioFrameDataManager.shared.getFrameDate(audio: audioData2, startInAudio: 0, length: 0, offset: 10)
        
        var minOffset: Double = 0
        let tracksModel = AudioTracksModel()
        var dataTracks = [AudioTrackModel]()
        
        dataFrames1.append(frame1)
        dataFrames1.append(frame2)
        dataFrames1.append(frame5)
        
        dataFrames2.append(frame3)
        dataFrames2.append(frame4)
        
        dataFrames3.append(frame6)
        
        dataTracks.append(AudioTrackDataManager.shared.getAudioTrackData(to: dataFrames1))
        dataTracks.append(AudioTrackDataManager.shared.getAudioTrackData(to: dataFrames2))
        dataTracks.append(AudioTrackDataManager.shared.getAudioTrackData(to: dataFrames3))
        
        // MARK: -  прижатие хотябы одного первого фрэйма к началу проекта
        
        for dataTrack in dataTracks {
            minOffset = max(minOffset, dataTrack.framesForTrack[0].offsetSecFrameToFrame)
        }
        for dataTrack in dataTracks {
            minOffset = min(minOffset, dataTrack.framesForTrack[0].offsetSecFrameToFrame)
        }
        for dataTrack in dataTracks {
            dataTrack.framesForTrack[0].offsetSecFrameToFrame = dataTrack.framesForTrack[0].offsetSecFrameToFrame - minOffset
        }
        
       //   расстановка позиций фрэймов и вычисление максимальной длинны дорожки и проверка смещения первого фрэйма каждого трэка
        for dataTrack in dataTracks {
            let frames = dataTrack.framesForTrack
            var length: Double = 0
            var startSecondFrameInTracks: Double = 0
            var startFrameInTracks: AVAudioFramePosition = 0
            
            for frame in frames {
                
                startSecondFrameInTracks += frame.offsetSecFrameToFrame
                frame.startSecFrameInTracks = startSecondFrameInTracks
                startSecondFrameInTracks += frame.lengthSecFrame
                
                startFrameInTracks += frame.offsetFrameToFrame
                frame.startFrameInTracks = startFrameInTracks
                startFrameInTracks += AVAudioFramePosition(frame.lengthFrame)
                
                length += (frame.lengthSecFrame + frame.offsetSecFrameToFrame)
            }
            if length > tracksModel.lengthSecTime { tracksModel.lengthSecTime = length}
        }
        tracksModel.trackForTracks = dataTracks
        return tracksModel
    }
}

