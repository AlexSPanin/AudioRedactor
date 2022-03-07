//
//  AENodeTableViewCellDelegate.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import UIKit

extension AudioEngineViewController: NodeTableViewCellDelegate {
    
    func button(for cell: NodeTableViewCell) {
        guard let frame = cell.dataAudioFrame else { return }
        
        if frame.addPlayListFrame {
            clearIsEditingFrames()
            viewEffect.isHidden = false
            frame.isEditingFrame = true
            activeEffectFrame = frame
            setupEffectValue()
            setupColorButtonPressedEffect(frame: frame, type: typeButtosEffect)
        }
        tableViewNode.reloadData()
        return
    }
    
    func addSwitch(for cell: NodeTableViewCell) {
        //      clearAddPlayer()
        
        if let frame = cell.dataAudioFrame {
            frame.addPlayListFrame = cell.switchAdd.isOn
            activeEffectFrame = frame
 //           print(activeEffectFrame?.audioForFrame.name.name)
        }
        checkAddPlayerNodes()
        tableViewNode.reloadData()
        return
    }
}
