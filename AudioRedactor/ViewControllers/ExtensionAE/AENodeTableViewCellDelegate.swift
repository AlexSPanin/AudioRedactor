//
//  AENodeTableViewCellDelegate.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import UIKit

extension AudioEngineViewController: FrameForTrackCollectionViewCellDelegate {
    
    // делегат нажатия на фрэйм
    
    func button(for index: String) {
        print(index)
        // поиск перебором выбранного фрэйма
        for dataPlayingNode in dataPlayingNodes {
            let frames = dataPlayingNode.framesForNode
            for frame in frames {
                if frame.index == index {
                    
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
        return
    }
}
