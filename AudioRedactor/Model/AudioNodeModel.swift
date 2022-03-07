//
//  AudioNodeModel.swift
//  AudioRedactor
//
//  Created by Александр Панин on 04.03.2022.
//

import AVFAudio

class AudioNodeModel {
    
    var framesForNode = [AudioFrameModel()]
    var nodeForSong = AudioDataModel()
    
    var addPlayListNode: Bool  = false                        //признак добавления к проигрованию
    var isEditingNode: Bool = false                           //признак активного редактирования
    var isPlayingNode: Bool = false                           //признак что началось проигрование
    var isPlayerReadyNode: Bool = false                       //признак что в плеере смонтирован аудио файл и плеер готов его проиговать
    var needsFileScheduledNode: Bool = true                   //признак необходимости смонтировать аудиофайл
    
    var seekFrameNode: AVAudioFramePosition = 0                // смещение позиции в узле
    var startFrameNodeInNodes: AVAudioFramePosition = 0        // стартовая позиция узла в массиве узлов
    var currentFrameNode: AVAudioFramePosition = 0             // текущая позиция в узле
    var audioLengthNode: AVAudioFramePosition = 0              // длина узла изначально равна сумме длин фрэймов
    
//    var audioPlayerNode = AVAudioPlayerNode()
//    var reverb = AVAudioUnitReverb()
//    var delayEcho = AVAudioUnitDelay()
//    var equalizer = AVAudioUnitEQ()
}
