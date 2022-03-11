//
//  AENodeTableViewCellDelegate.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import UIKit

extension AudioEngineViewController: AudioEngineViewControllerDelegate {
    
    // делегат нажатия на фрэйм
    
    func update(for index: String) {
       indexActiveFrame = index
    }
}
