//
//  AENodeTableViewCellDelegate.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import UIKit

extension AudioEngineViewController: AudioEngineViewControllerDelegate {
    
    // делегат нажатия на фрэйм и обновление активного фрэйма
    
    func update(for index: String) {
       indexActiveFrame = index
        updateIndexActiveFrame()
    }
    
    func updateIndexActiveFrame() {
        for dataPlayingNode in dataPlayingNodes {
            let frames = dataPlayingNode.framesForNode
            for frame in frames {
                if frame.index == indexActiveFrame {
                    
                    
                    print(frame.audioForFrame.name.name) // временно для контроля активного фрэйма
                    
                    
                    // отчистка признака редактирования у всех фрэймов и включение эффектов
                    clearIsEditingFrames()
                    viewEffect.isHidden = false
                    
                    // установка выбранному фрэйму признака редактирования и признака активного фрэйма
                    frame.isEditingFrame = true
                    activeEffectFrame = frame
                    
                    // установка текущих значений эффектов и активных кнопок
                    setupEffectValue()
                    setupColorButtonPressedEffect(frame: frame, type: typeButtosEffect)
                    
                    // обновление представлений
                    setupScrollTableView()
                    tableViewNode.reloadData()
                    return
                }
            }
        }
    }
    
}
