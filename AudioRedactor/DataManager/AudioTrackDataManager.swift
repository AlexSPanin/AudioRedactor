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
        audioTrack.framesForNode = frames
        for frame in frames {
           
            audioTrack.lengthSecondTrack += frame.lengthSecondFrame
        }
        return audioTrack
    }
}
