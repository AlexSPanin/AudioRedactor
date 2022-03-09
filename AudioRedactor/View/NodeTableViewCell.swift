//
//  NodeTableViewCell.swift
//  AudioEngine
//
//  Created by Александр Панин on 21.02.2022.
//

import UIKit

class NodeTableViewCell: UITableViewCell {
    
    var delegate: NodeTableViewCellDelegate!

    let nameLabel: UILabel = {
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
    
    let lengthLabel: UILabel = {
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
    
    let currentLabel: UILabel = {
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
 
    let progress: UIProgressView = {
        let progress = UIProgressView()
        let setting = Setting.getSetting()
        progress.setProgress(1, animated: true)
        progress.progressTintColor = setting.colorTint

        return progress
    }()
    
    var frames = [UIImageView]()
    
    var currentPositionX: CGFloat = 0
    
    private let setting = Setting.getSetting()

    @objc func selectButton(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        guard  let index = imageView.restorationIdentifier else { return }
        print(index)
        delegate.button(for: index)
    }
    
    func configure( frames: [AudioFrameModel], indexRow: Int) {
        
        for frame in frames {
            configureUICell(to: frame)
        }
        
        
        backgroundColor = (indexRow + 1) % 2 == 1 ? .white : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        selectionStyle = .none
        
    }
    
    
    private func configureUICell(to frame: AudioFrameModel) {
        
        let width = CGFloat(frame.lengthSecondsFrame * 5)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectButton))
        let frameImageView = UIImageView()
        frameImageView.isUserInteractionEnabled = true
        frameImageView.addGestureRecognizer(tapGestureRecognizer)
        
        frameImageView.frame = CGRect(x: 0, y: 0, width: width, height: self.contentView.bounds.height)
        frameImageView.layer.cornerRadius = 5
        frameImageView.backgroundColor = frame.isEditingFrame ? #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1) : #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        frameImageView.layer.borderColor =  frame.isEditingFrame ? #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1) : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        frameImageView.layer.borderWidth = 1
        frameImageView.restorationIdentifier = frame.index
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, lengthLabel, currentLabel])
        stack.frame = CGRect(x: 0, y: 0, width: width, height: self.contentView.bounds.height)
        stack.axis = .vertical
        stack.spacing = 2
        stack.distribution = UIStackView.Distribution.fillEqually
        
        frameImageView.addSubview(progress)
        
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.leftAnchor.constraint(equalTo: frameImageView.leftAnchor, constant: 2).isActive = true
        progress.rightAnchor.constraint(equalTo: frameImageView.rightAnchor, constant: -2).isActive = true
        progress.bottomAnchor.constraint(equalTo: frameImageView.bottomAnchor, constant: -4).isActive = true
        progress.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        frameImageView.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leftAnchor.constraint(equalTo: frameImageView.leftAnchor, constant: 2).isActive = true
        stack.rightAnchor.constraint(equalTo: frameImageView.rightAnchor, constant: -2).isActive = true
        stack.topAnchor.constraint(equalTo: frameImageView.topAnchor, constant: 2).isActive = true
        stack.bottomAnchor.constraint(equalTo: progress.topAnchor, constant: -2).isActive = true
        
        self.contentView.addSubview(frameImageView)
        
        frameImageView.translatesAutoresizingMaskIntoConstraints = false
        frameImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        frameImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        frameImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        
        let time = Float(frame.currentFrame) / Float(frame.audioForFrame.audioSampleRate)
        let length = Float(frame.countFrame) / Float(frame.audioForFrame.audioSampleRate)
       
        progress.progress = ( Float(frame.currentFrame) / Float(frame.audioForFrame.audioSampleRate) ) / length
        progress.trackTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       
        nameLabel.text = String("\(frame.audioForFrame.name.name) - \(frame.audioForFrame.name.format)")
        currentLabel.text = String("Current Time:  \(PlayerTime.getFormattedTime(seconds: time))")
        lengthLabel.text = String("Total length: \(PlayerTime.getFormattedTime(seconds: length))")
        

    }

}
