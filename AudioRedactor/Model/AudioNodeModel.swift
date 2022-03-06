//
//  AudioNodeModel.swift
//  AudioRedactor
//
//  Created by Александр Панин on 04.03.2022.
//

import Foundation
import AVFAudio

class DataAudioNode {
    
    var frameForNode = DataAudioFrame
    var nodeForSong = AudioData()
    
    var addPlayList: Bool  = false                        //признак добавления к проигрованию
    var isEditing: Bool = false                           //признак активного редактирования
    var isPlaying: Bool = false                           //признак что началось проигрование
    var isPlayerReady: Bool = false                       //признак что в плеере смонтирован аудио файл и плеер готов его проиговать
    var needsFileScheduled: Bool = true                   //признак необходимости смонтировать аудиофайл
    
    var seekFrame: AVAudioFramePosition = 0
    var currentPosition: AVAudioFramePosition = 0
//    var audioSeekFrame: AVAudioFramePosition = 0
    var currentFrame: AVAudioFramePosition = 0            //текущий фрэйм
    
    var audioPlayerNode = AVAudioPlayerNode()
    var reverb = AVAudioUnitReverb()
    var delayEcho = AVAudioUnitDelay()
    var equalizer = AVAudioUnitEQ()
}
