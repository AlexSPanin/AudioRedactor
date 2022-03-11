//
//  TrackCollectionViewCell.swift
//  AudioRedactor
//
//  Created by Александр Панин on 09.03.2022.
//

import UIKit

class FrameForTrackCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "Frame"
    
    var frameInTrack: AudioFrameModel?
    var delegate: AudioEngineViewControllerDelegate!
    
    private var frameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        let setting = Setting.getSetting()
        guard let font = UIFont(name: setting.nameFont, size: setting.normalSize) else {return label }
        label.font = font
        label.textColor = setting.colorTint
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let lengthLabel: UILabel = {
        let label = UILabel()
        let setting = Setting.getSetting()
        guard let font = UIFont(name: setting.nameFont, size: setting.normalSize) else {return label }
        label.font = font
        label.textColor = setting.colorTint
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    private let currentLabel: UILabel = {
        let label = UILabel()
        let setting = Setting.getSetting()
        guard let font = UIFont(name: setting.nameFont, size: setting.normalSize) else {return label }
        label.font = font
        label.textColor = setting.colorTint
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let progress: UIProgressView = {
        let progress = UIProgressView()
        let setting = Setting.getSetting()
        progress.setProgress(1, animated: true)
        progress.progressTintColor = setting.colorTint
        progress.trackTintColor = .white
        return progress
    }()
    
   
    
    func configure() {
        
        guard let frameInTrack = frameInTrack else { return }
       
        let time = Float(frameInTrack.currentSecFrame)
        let length = Float(frameInTrack.lengthSecFrame)
        let width = CGFloat(frameInTrack.offsetSecFrameToFrame * 5)
        
        frameImageView.backgroundColor = frameInTrack.isEditingFrame ? #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1) : #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        frameImageView.layer.borderColor =  frameInTrack.isEditingFrame ? #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1) : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        
        
        frameImageView.restorationIdentifier = frameInTrack.index
        
        frameImageView.addSubview(progress)
        
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.leftAnchor.constraint(equalTo: frameImageView.leftAnchor, constant: 2).isActive = true
        progress.rightAnchor.constraint(equalTo: frameImageView.rightAnchor, constant: -2).isActive = true
        progress.bottomAnchor.constraint(equalTo: frameImageView.bottomAnchor, constant: -4).isActive = true
        progress.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, lengthLabel, currentLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.distribution = UIStackView.Distribution.fillEqually
        
        frameImageView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leftAnchor.constraint(equalTo: frameImageView.leftAnchor, constant: 2).isActive = true
        stack.rightAnchor.constraint(equalTo: frameImageView.rightAnchor, constant: -2).isActive = true
        stack.topAnchor.constraint(equalTo: frameImageView.topAnchor, constant: 2).isActive = true
        stack.bottomAnchor.constraint(equalTo: progress.topAnchor, constant: -2).isActive = true
        
        addSubview(frameImageView)
        
        frameImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: width).isActive = true
        frameImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        frameImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        frameImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        nameLabel.text = String("\(frameInTrack.audioForFrame.name.name) - \(frameInTrack.audioForFrame.name.format)")
        lengthLabel.text = String("Total length: \(PlayerTime.getFormattedTime(seconds: length))")
        currentLabel.text = String("Current Time:  \(PlayerTime.getFormattedTime(seconds: time))")
        progress.progress = Float(frameInTrack.currentSecFrame) / length
    }
    
}
