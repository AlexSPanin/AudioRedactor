//
//  AENodeTableViewCellDelegate.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import UIKit

extension AudioEngineViewController: NodeTableViewCellDelegate {
    
    func button(for index: String) {
        
        print(index)
        
        for dataPlayingNode in dataPlayingNodes {
            let frames = dataPlayingNode.framesForNode
            for frame in frames {
                    if frame.index == index {
                        print(frame.audioForFrame.name.name)
                        clearIsEditingFrames()
                        viewEffect.isHidden = false
                        frame.isEditingFrame = true
                        activeEffectFrame = frame
                        setupEffectValue()
                        setupColorButtonPressedEffect(frame: frame, type: typeButtosEffect)
                        setupScrollTableView()
                        tableViewNode.reloadData()
                        return
                    }
                }
        }
        return
    }
}
