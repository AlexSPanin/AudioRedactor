//
//  EffectModel.swift
//  AudioRedactor
//
//  Created by Александр Панин on 06.03.2022.
//

import Foundation

//MARK: -  настройки эффектов и громкости на фрагмент

class EffectFrameModel {
    
    var volume: Float = 0.2
    var eqLow: Float = 10000
    var eqHight: Float = 0
    var reverb: Float = 0
    var delay: Float = 0
    var incVolume = [VolumeFrameModel]()
}
