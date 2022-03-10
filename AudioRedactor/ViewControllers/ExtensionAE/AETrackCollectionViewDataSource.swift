//
//  AETrackCollectionViewDataSource.swift
//  AudioRedactor
//
//  Created by Александр Панин on 10.03.2022.
//


import UIKit


extension AudioEngineViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        frames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: FrameForTrackCollectionViewCell.reuseId, for: indexPath) as! FrameForTrackCollectionViewCell
      //  cell.frameImageView.frame = CGRect(x: 0, y: 0, width: (frames[indexPath.row].lengthSecondsFrame * 5), height: 80)
        cell.frameInTrack = frames[indexPath.row]
        cell.restorationIdentifier = frames[indexPath.row].index
        cell.configure()
        return cell
    }
    
    
}
  
