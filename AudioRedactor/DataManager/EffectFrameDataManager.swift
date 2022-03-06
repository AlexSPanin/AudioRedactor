//
//  EffectFrameDataManager.swift
//  AudioRedactor
//
//  Created by Александр Панин on 06.03.2022.
//

import Foundation

class EffectFrameDataManager {
    static var shared = EffectFrameDataManager()
    private init() {}
    
    func getEffectDate() -> EffectFrameModel {
        let dataEffectFrame = EffectFrameModel()
        return dataEffectFrame
    }
}
