//
//  AudioFrameModel.swift
//  AudioRedactor
//
//  Created by Александр Панин on 06.03.2022.
//

import AVFAudio

class AudioFrameModel {
    var audioForFrame = AudioDataModel()                   // привязка фрэйма к музыкальному трэку
    var effectFrame = EffectFrameModel()                   // набор эффектов к фрэйму
    
    var addPlayListFrame: Bool  = false                        //признак добавления к проигрованию
    var isEditingFrame: Bool = false                           //признак активного редактирования
    var isPlayingFrame: Bool = false                           //признак что началось проигрование
    var isPlayerReadyFrame: Bool = false                       //признак что в плеере смонтирован аудио файл и плеер готов его проигровать
    var needsFileScheduledFrame: Bool = true                   //признак необходимости смонтировать аудиофайл
    
    var seekFrame: AVAudioFramePosition = 0                  // смещение по фрэйму
    var startFrameInNode: AVAudioFramePosition = 0           // стартовая позиция фрэйма в ноде
    var currentFrame: AVAudioFramePosition = 0               // текущая позиция воспроизведения во фрэйме
    var lengthFrame: AVAudioFramePosition = 0                // длина фрэйма изначально равна длинне музыкальноко трэка
    
    var playerFrame = AVAudioPlayerNode()
    var reverbFrame = AVAudioUnitReverb()
    var delayEchoFrame = AVAudioUnitDelay()
    var equalizerFrame = AVAudioUnitEQ()
}
