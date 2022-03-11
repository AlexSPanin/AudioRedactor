//
//  AudioFrameDataManager.swift
//  AudioRedactor
//
//  Created by Александр Панин on 06.03.2022.
//

import AVFAudio

class AudioFrameDataManager {
    static var shared = AudioFrameDataManager()
    private init() {}
    
    func getFrameDate(audio: AudioDataModel, startInAudio: Double, length: Double, offset: Double ) -> AudioFrameModel {
           
        let dataAudioFrame = AudioFrameModel()
        dataAudioFrame.audioForFrame = audio
        dataAudioFrame.effectFrame = EffectFrameModel()
        
        let sampleRate = audio.audioSampleRate
        // начало фрэйма в связанном аудиофайле
        dataAudioFrame.startSecondFrameInAudio = startInAudio
        dataAudioFrame.startFrameInAudio = AVAudioFramePosition(startInAudio * sampleRate)
        // длина фрэйма в связанном аудиофайле
        dataAudioFrame.lengthSecondFrame = length
        dataAudioFrame.lengthFrame = AVAudioFramePosition(length * sampleRate)
        // смещение фрэйма от предыдущего фрейма или начала трэка
        dataAudioFrame.offsetSecondFrameToFrame = offset
        dataAudioFrame.offsetFrameToFrame = AVAudioFramePosition(offset * sampleRate)
        
        return dataAudioFrame
    }
}
