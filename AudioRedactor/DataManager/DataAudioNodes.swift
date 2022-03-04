//
//  DataNodes.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import Foundation
import AVFAudio





class DataPlayingNodes {
    
    static var shared = DataPlayingNodes()
    
    private init() {}
    
    func getDataPlayingNodes() -> [DataAudioNode] {
        var dataPlayingNodes: [DataAudioNode] = []
        let dataSongs = DataSong.getDataSong()
        
        for dataSong in dataSongs {
            
            dataPlayingNodes.append(
                DataAudioNode(
                    nodeForSong: dataSong,
                    addPlayList: false,
                    isEditing: false,
                    isPlaying: false,
                    isPlayerReady: false,
                    needsFileScheduled: true,
                    seekFrame: 0,
                    currentPosition: 0,
                    audioSeekFrame: 0,
   //                 audioLengthSamples: 0,
                    currentFrame: 0,
                    audioPlayerNode: AVAudioPlayerNode(),
                    reverb: AVAudioUnitReverb(),
                    delayEcho: AVAudioUnitDelay(),
                    equalizer: AVAudioUnitEQ(numberOfBands: 1)
                )
            )
        }
        return dataPlayingNodes
    }
}

