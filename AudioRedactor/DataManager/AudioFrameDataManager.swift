//
//  AudioFrameDataManager.swift
//  AudioRedactor
//
//  Created by Александр Панин on 06.03.2022.
//

class AudioFrameDataManager {
    static var shared = AudioFrameDataManager()
    private init() {}
    
    func getFrameDate(to audio: AudioDataModel) -> AudioFrameModel {
        let dataAudioFrame = AudioFrameModel()
        dataAudioFrame.audioForFrame = audio
        dataAudioFrame.effectFrame = EffectFrameModel()
        dataAudioFrame.countFrame = audio.audioLengthSamples
        dataAudioFrame.lengthSecondsFrame = audio.audioLengthSeconds
        return dataAudioFrame
    }
}
