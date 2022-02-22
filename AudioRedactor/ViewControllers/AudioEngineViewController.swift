//
//  AudioEngineViewController.swift
//  AudioEngine
//
//  Created by Александр Панин on 02.02.2022.
//

import UIKit
import AVFoundation

protocol NodeTableViewCellDelegate {
    func button (for cell: NodeTableViewCell)
    func addSwitch ( for cell: NodeTableViewCell)
}

class AudioEngineViewController: UIViewController {
    
    // MARK: - User Interface
    
    weak var tableViewNode: UITableView!
    
    // Player View
    var buttonsPlayer: [UIButton] = []
    var stackPlayer = UIStackView()
    
    // Editor View
    let viewEditor = UIView()
    var buttonsEditor: [UIButton] = []
    var stackEditor = UIStackView()
    
    
    // MARK: - Effect View
    // Effect View
    let viewEffect = UIView()
    var stackEffect = UIStackView()
    
    // Effect Buttons
    var buttonsEffect: [UIButton] = []
    var labelsEffect: [UILabel] = []
    var stackEffectButton = UIStackView()
    var stackEffectLabel = UIStackView()
    
    //Effect Sliders
    var slidersEffect = UISlider()
    var slidersTextEffect: [UILabel] = []
    var slidersImageEffect: [UIImageView] = []
    var stackEffectSlider = UIStackView()
    var stackEffectText = UIStackView()
    var stackEffectImage = UIStackView()
    
    // MARK: - AudioEngine
    // Mixer and Engine
    var audioFile: AVAudioFile?
    let audioEngine = AVAudioEngine()
    let audioMixer = AVAudioMixerNode()
    let micMixer = AVAudioMixerNode()
    
    // MARK: - Data Songs and Settings UI and start value
    var setting = Setting.getSetting()
    var dataSongs = DataSong.getDataSong()
    var dataPlayingNodes = DataPlayingNodes.shared.getDataPlayingNodes()
    
    
    // MARK: - number song and start button effect
    var activeEffectNode: Int = 0
    var isActiveAddPlayer: Bool = false
    var typeButtosEffect: ButtonsEffect = .volume
   
    // состояние плееров общее играют или нет
    var isPlaying: Bool = false
    
    // значения настроек слайдеров по песням
    var tracksSlidersValue = TrackSlidersValue.getTrackSlidersValue()
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        

        setupUI(track: activeEffectNode, type: typeButtosEffect)
        
        setupEffectValue()
        configureEngine(dataSongs)
        
        self.tableViewNode.register(NodeTableViewCell.self, forCellReuseIdentifier: "nodeCell")
        self.tableViewNode.dataSource = self
       
    }
    
    override func loadView() {
        super.loadView()
        
        let tableView = UITableView()
        tableView.rowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        
        self.tableViewNode = tableView
    }
    
   
    
    
    
   
    
    //MARK: - Подготовка аудио движка
    
    func configureEngine(_ dataSongs: [DataSong]) {
        // setting start value effect
        configureSetupEffect()
        
        // старт движка и монтирование аудифайлов
        do {
            try audioEngine.start()
            
            for dataPlayingNode in dataPlayingNodes {
                scheduleAudioFile(dataPlayingNode)
            }
        } catch {
            print("error configure Engine")
        }
    }
    
        // MARK: - create audio file and setting sign for ready play
    func scheduleAudioFile(_ node: DataPlayingNode) {
        var audioNode = node
        let audioFile = audioNode.nodeForSong.file
        if audioNode.needsFileScheduled { audioNode.audioPlayerNode.scheduleFile(audioFile, at: nil) }
        audioNode.needsFileScheduled.toggle()
        audioNode.isPlayerReady.toggle()
    }
    
    // MARK: -  запуск воспроизведения или пауза
    
    func playButton() {
        
        if isActiveAddPlayer {
            
            for dataPlayingNode in dataPlayingNodes {
                if dataPlayingNode.addPlayList {
                    if dataPlayingNode.needsFileScheduled { scheduleAudioFile(dataPlayingNode)}
                    
                    switch isPlaying {
                        
                    case true:
                        dataPlayingNode.audioPlayerNode.pause()
                    case false:
                        dataPlayingNode.audioPlayerNode.play()
                    }
                }
            }
            isPlaying.toggle()
            changeImageButtonPlayPause(isPlaying)
            tableViewNode.reloadData()
        }
    }
    
    
    func clearIsEditing() {
        let count = dataPlayingNodes.count - 1
        for index in 0...count {
            dataPlayingNodes[index].isEditing = false
        }
    }
  
    func checkAddPlayer() {
       isActiveAddPlayer = dataPlayingNodes.contains { data in
            data.addPlayList
        }
    }
    
    func hiddenEffectView() {
        viewEffect.isHidden = true
        tableViewNode.reloadData()
    }
}
