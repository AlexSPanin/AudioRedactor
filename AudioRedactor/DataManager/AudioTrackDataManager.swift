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
        var startSecondFrameInTrack: Double = 0
        var startFrameInTrack: AVAudioFramePosition = 0
        
        audioTrack.framesForTrack = frames
        
        for frame in frames {
            
            frame.startSecFrameInTracks = startSecondFrameInTrack
            startSecondFrameInTrack += (frame.lengthSecFrame + frame.offsetSecFrameToFrame)
            
            frame.startFrameInTrack = startFrameInTrack
            startFrameInTrack += (AVAudioFramePosition(frame.lengthFrame) + frame.offsetFrameToFrame)
            
            audioTrack.lengthSecTrack += frame.lengthSecFrame
            audioTrack.currentSecTrack = 0
            
        }
        return audioTrack
    }
}
