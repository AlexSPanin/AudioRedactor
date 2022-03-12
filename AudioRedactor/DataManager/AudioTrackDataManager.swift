//
//  AudioNodeDataManager.swift
//  AudioRedactor
//
//  Created by Александр Панин on 06.03.2022.
//

import AVFAudio

class AudioTrackDataManager {
    static var shared = AudioTrackDataManager()
    private init() {}
    
    func getAudioTrackData(to frames: [AudioFrameModel]) -> AudioTrackModel {
        let audioTrack = AudioTrackModel()
        var startSecondFrameInTracks: Double = 0
        var startFrameInTracks: AVAudioFramePosition = 0
        
        audioTrack.framesForTrack = frames
        
        for frame in frames {
            
            // расстановка фрэймов по трэку
            // определяем точку старта по трэку с учетом смещения от предыдущего и задем стартовую точку
            startSecondFrameInTracks += frame.offsetSecFrameToFrame
            frame.startSecFrameInTracks = startSecondFrameInTracks
            // увеличиваем стартовую точку на продолжительность фрэйма
            startSecondFrameInTracks += frame.lengthSecFrame
            
            startFrameInTracks += frame.offsetFrameToFrame
            frame.startFrameInTracks = startFrameInTracks
            startFrameInTracks += AVAudioFramePosition(frame.lengthFrame)
            
        
//            audioTrack.lengthSecTrack += frame.lengthSecFrame
//            audioTrack.currentSecTrack = 0
            
        }
        return audioTrack
    }
}
