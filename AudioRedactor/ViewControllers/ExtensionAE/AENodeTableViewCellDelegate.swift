//
//  AENodeTableViewCellDelegate.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import UIKit

extension AudioEngineViewController: NodeTableViewCellDelegate {
    
    func button(for cell: NodeTableViewCell) {
        
        guard let index = cell.dataAudioFrame?.index else { return }
        
        for dataPlayingNode in dataPlayingNodes {
            let frames = dataPlayingNode.framesForNode
            for frame in frames {
                if frame.addPlayListFrame {
                    if frame.index == index {
                        print(frame.audioForFrame.name.name)
                        clearIsEditingFrames()
                        viewEffect.isHidden = false
                        frame.isEditingFrame = true
                        activeEffectFrame = frame
                        setupEffectValue()
                        setupColorButtonPressedEffect(frame: frame, type: typeButtosEffect)
                        tableViewNode.reloadData()
                        return
                    }
                }
            }
        }
        return
    }
    
    func addSwitch(for cell: NodeTableViewCell) {
        
        guard let index = cell.dataAudioFrame?.index else { return }
        
        for dataPlayingNode in dataPlayingNodes {
            let frames = dataPlayingNode.framesForNode
            for frame in frames {
                if frame.index == index {
                    frame.addPlayListFrame = cell.switchAdd.isOn
                    if frame.isEditingFrame {
                        hiddenEffectView()
                        frame.isEditingFrame.toggle()
                    }
                    activeEffectFrame = frame
                    checkAddPlayerNodes()
                    tableViewNode.reloadData()
                    return
                }
            }
        }
        return
    }

}
