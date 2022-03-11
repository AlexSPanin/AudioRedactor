//
//  TrackCollectionView.swift
//  AudioRedactor
//
//  Created by Александр Панин on 09.03.2022.
//

import UIKit

class TrackCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var frames = [AudioFrameModel]()
    var delegateTVCellToAE: AudioEngineViewControllerDelegate?
    
  init() {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        delegate = self
        dataSource = self
        register(FrameForTrackCollectionViewCell.self, forCellWithReuseIdentifier: FrameForTrackCollectionViewCell.reuseId)
      translatesAutoresizingMaskIntoConstraints = false
      layout.minimumLineSpacing = 0
      layout.minimumInteritemSpacing = 0
      showsVerticalScrollIndicator = false
      showsHorizontalScrollIndicator = false
      isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFrames(to frames: [AudioFrameModel]) {
        self.frames = frames
    }
   
}
extension TrackCollectionView {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        frames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: FrameForTrackCollectionViewCell.reuseId, for: indexPath) as! FrameForTrackCollectionViewCell
        cell.frameInTrack = frames[indexPath.row]
        cell.restorationIdentifier = frames[indexPath.row].index
        cell.configure()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthLengthOffset = CGFloat((frames[indexPath.row].lengthSecFrame + frames[indexPath.row].offsetSecFrameToFrame) * 5)
        return CGSize(width: widthLengthOffset, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let index = cellForItem(at: indexPath)?.restorationIdentifier else { return }
        delegateTVCellToAE?.update(for: index)
    }
}
