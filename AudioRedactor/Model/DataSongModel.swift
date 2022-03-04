//
//  DataSongModel.swift
//  AudioRedactor
//
//  Created by Александр Панин on 04.03.2022.
//

import Foundation
import AVFAudio

class DataSong {
    var name = Song()
    var file = AVAudioFile()
    var audioLengthSamples: AVAudioFramePosition = 0
    var audioLengthSeconds: Double = 0
    var audioSampleRate: Double = 0
    var audioFormat = AVAudioFormat()
}

