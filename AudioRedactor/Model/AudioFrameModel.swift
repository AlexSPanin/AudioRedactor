//
//  AudioFrameModel.swift
//  AudioRedactor
//
//  Created by Александр Панин on 06.03.2022.
//

import AVFAudio

class AudioFrameModel {
    var index = UUID().uuidString
    var audioForFrame = AudioDataModel()                   // привязка фрэйма к музыкальному трэку
    var effectFrame = EffectFrameModel()                   // набор эффектов к фрэйму
    
    var isEditingFrame: Bool = false                           //признак активного редактирования
    var isPlayingFrame: Bool = false                           //признак что началось проигрование
    var isPlayerReadyFrame: Bool = false                       //признак что в плеере смонтирован аудио файл и плеер готов его проигровать
    var needsFileScheduledFrame: Bool = true                   //признак необходимости смонтировать аудиофайл
    
    var seekFrame: AVAudioFramePosition = 0                  // смещение по фрэйму
    var startFrameInTrack: AVAudioFramePosition = 0           // стартовая позиция фрэйма в ноде
    var startFrameInAudio: AVAudioFramePosition = 0
    var currentFrame: AVAudioFramePosition = 0               // текущая позиция воспроизведения во фрэйме
    var lengthFrame: AVAudioFramePosition = 0                // длина фрэйма изначально равна длинне музыкальноко трэка
    
    var startSecondFrameInTrack: Double = 0
    var startSecondFrameInAudio: Double = 0
    var currentSecondFrame: Double = 0
    var lengthSecondsFrame: Double = 0
    
    var playerFrame = AVAudioPlayerNode()
    var reverbFrame = AVAudioUnitReverb()
    var delayEchoFrame = AVAudioUnitDelay()
    var equalizerFrame = AVAudioUnitEQ()
}
