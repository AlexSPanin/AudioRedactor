//
//  TrackCollectionView.swift
//  AudioRedactor
//
//  Created by Александр Панин on 09.03.2022.
//

import UIKit

class TrackCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var dataPlayingNodes = [AudioTrackModel]()
    
  init() {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .vertical
      super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        delegate = self
        dataSource = self
        register(FrameForTrackCollectionViewCell.self, forCellWithReuseIdentifier: FrameForTrackCollectionViewCell.reuseId)
      layout.sectionHeadersPinToVisibleBounds = true
      layout.headerReferenceSize =  CGSize(width: self.frame.width, height: 50)
  
      layout.minimumLineSpacing = 0
      layout.minimumInteritemSpacing = 0
     
      showsVerticalScrollIndicator = false
      showsHorizontalScrollIndicator = true
      isScrollEnabled = true
      bounces = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTracks(to tracks: [AudioTrackModel]) {
        dataPlayingNodes = tracks
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataPlayingNodes.count
    }
    
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataPlayingNodes[section].framesForNode.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FrameForTrackCollectionViewCell.reuseId, for: indexPath) as! FrameForTrackCollectionViewCell
  
        cell.frameInTrack = dataPlayingNodes[indexPath.section].framesForNode[indexPath.row]
        cell.configure()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (dataPlayingNodes[indexPath.section].framesForNode[indexPath.row].lengthSecondsFrame * 5), height: 80)
    }
    
    
}
