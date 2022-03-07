//
//  AudioNodeDataManager.swift
//  AudioRedactor
//
//  Created by Александр Панин on 06.03.2022.
//

import AVFAudio

class AudioNodeDataManager {
    static var shared = AudioNodeDataManager()
    private init() {}
    
    func getAudioNodeData(to frames: [AudioFrameModel]) -> AudioNodeModel {
        let audioNode = AudioNodeModel()
        audioNode.framesForNode = frames
        for frame in frames {
            frame.startFrameInNode = audioNode.audioLengthNode
            audioNode.audioLengthNode += frame.lengthFrame
        }
        return audioNode
    }
}