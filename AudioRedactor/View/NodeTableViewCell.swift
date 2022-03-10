//
//  NodeTableViewCell.swift
//  AudioEngine
//
//  Created by Александр Панин on 21.02.2022.
//

//import UIKit
//
//class NodeTableViewCell: UITableViewCell {
//    
//  
//
//    var currentPositionX: CGFloat = 0
//    
//    private let setting = Setting.getSetting()
//    
//
//    func configure( frames: [AudioFrameModel]) {
//        
//        let trackCollectionView = TrackCollectionView()
//        
//        self.contentView.addSubview(trackCollectionView)
//        
//        
//        trackCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        trackCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        trackCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        trackCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        
//        trackCollectionView.setFrames(to: frames)
// 
//        selectionStyle = .none
//    }
//
//}
