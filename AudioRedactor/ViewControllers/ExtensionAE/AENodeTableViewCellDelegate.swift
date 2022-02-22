//
//  AENodeTableViewCellDelegate.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import UIKit

extension AudioEngineViewController: NodeTableViewCellDelegate {
    
    func button(for cell: NodeTableViewCell) {
        guard let node = cell.indexCell else { return }
        
        if dataPlayingNodes[node].addPlayList {
            clearIsEditing()
            viewEffect.isHidden = false
            dataPlayingNodes[node].isEditing = true
            activeEffectNode = node
            setupEffectValue()
            setupColorButtonPressedEffect(track: activeEffectNode, type: typeButtosEffect)
        }
        tableViewNode.reloadData()
        return
    }
    
    func addSwitch(for cell: NodeTableViewCell) {
        //      clearAddPlayer()
        
        if let node = cell.indexCell {
            dataPlayingNodes[node].addPlayList = cell.switchAdd.isOn
            
            activeEffectNode = node
            
        }
        checkAddPlayer()
        tableViewNode.reloadData()
        return
    }
}
