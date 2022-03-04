//
//  DataSongs.swift
//  AudioEngine
//
//  Created by Александр Панин on 18.02.2022.
//

import Foundation
import AVFAudio

struct DataSongs {
    let name: Songs
    let file: AVAudioFile
    let audioLengthSamples: AVAudioFramePosition
    let audioLengthSeconds: Double
    let audioSampleRate: Double
    let audioFormat: AVAudioFormat
    
    private var lengthSeconds: Double {
        Double(audioLengthSeconds) / audioSampleRate
    }
    static func getDataSong() -> DataSong{
        let music = Songs.getSongs()
        var dataSongs: [DataSong] = []
        for song in music {
            guard let url = Bundle.main.url(forResource: song.name, withExtension: song.format) else {
                
                return dataSongs}
            do {
                let file = try AVAudioFile(forReading: url)
                let format = file.processingFormat
                let dataSong = DataSong(
                    name: song,
                    file: file,
                    audioLengthSamples: file.length,
                    audioLengthSeconds: Double(file.length) / format.sampleRate,
                    audioSampleRate: format.sampleRate,
                    audioFormat: format
                )
                dataSongs.append(dataSong)
            } catch {
                print("error Setup Audio")
            }
        }
        return dataSongs
    }
}

