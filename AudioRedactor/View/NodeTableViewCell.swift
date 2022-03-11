//
//  NodeTableViewCell.swift
//  AudioEngine
//
//  Created by Александр Панин on 21.02.2022.
//

import UIKit

class NodeTableViewCell: UITableViewCell, AudioEngineViewControllerDelegate {
   
    var delegate: AudioEngineViewControllerDelegate!

    func configure( frames: [AudioFrameModel]) {
        
        let trackCollectionView = TrackCollectionView()
        trackCollectionView.backgroundColor = .white
        
        self.contentView.addSubview(trackCollectionView)
        
        trackCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        trackCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        trackCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        trackCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        trackCollectionView.delegateTVCellToAE = self
        trackCollectionView.setFrames(to: frames)
 
        selectionStyle = .none
    }
    
    func update(for index: String) {
        delegate.update(for: index)
    }

}
