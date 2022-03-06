//
//  AudioFrameModel.swift
//  AudioRedactor
//
//  Created by Александр Панин on 06.03.2022.
//

import AVFAudio

class AudioFrameModel {
    var audioForFrame = AudioDataModel()
    var effectFrame = EffectFrameModel()
    
    var addPlayList: Bool  = false                        //признак добавления к проигрованию
    var isEditing: Bool = false                           //признак активного редактирования
    var isPlaying: Bool = false                           //признак что началось проигрование
    var isPlayerReady: Bool = false                       //признак что в плеере смонтирован аудио файл и плеер готов его проиговать
    var needsFileScheduled: Bool = true                   //признак необходимости смонтировать аудиофайл
    
    var currentPosition: AVAudioFramePosition = 0
    var seekFrame: AVAudioFramePosition = 0
    var startFrame: AVAudioFramePosition = 0
    var currentFrame: AVAudioFramePosition = 0
    var endFrame: AVAudioFramePosition = 0
    
}
