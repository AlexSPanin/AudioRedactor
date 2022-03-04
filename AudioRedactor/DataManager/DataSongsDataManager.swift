//
//  DataSongs.swift
//  AudioEngine
//
//  Created by Александр Панин on 18.02.2022.
//

import Foundation
import AVFAudio

class DataSongsDataManager {
    
    static let shared = DataSongsDataManager()
    private init() {}
    
    func fetchDataSongs() -> [DataSong] {
        let music = SongsDataManager.shared.fetchSongs()
        var dataSongs = [DataSong]()
        
        for song in music {
            guard let url = Bundle.main.url(forResource: song.name, withExtension: song.format) else { return dataSongs }
            do {
                let file = try AVAudioFile(forReading: url)
                let format = file.processingFormat
                let dataSong = DataSong()
                dataSong.name = song
                dataSong.file = file
                dataSong.audioLengthSamples = file.length
                dataSong.audioLengthSeconds = Double(file.length) / format.sampleRate
                dataSong.audioSampleRate = format.sampleRate
                dataSong.audioFormat = format
                dataSongs.append(dataSong)
            } catch {
                print("error Setup Audio")
            }
        }
        return dataSongs
    }
}

