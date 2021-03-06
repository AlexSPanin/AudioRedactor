//
//  Music.swift
//  AudioEngine
//
//  Created by Александр Панин on 12.02.2022.
//

import Foundation


class SongsDataManager {
    static let shared = SongsDataManager()
    private init() {}
    
    func fetchSongs() -> [SongModel] {
        
        var songs = [SongModel]()
        
        let song1 = SongModel()
        song1.name = "Scott Buckley - Life In Silico"
        song1.format = Format.mp3.rawValue
        songs.append(song1)
        
        let song2 = SongModel()
        song2.name = "otbivka"
        song2.format = Format.mp3.rawValue
        songs.append(song2)
        
        let song3 = SongModel()
        song3.name = "01 The St. Louis Blues"
        song3.format = Format.m4a.rawValue
        songs.append(song3)
        
        return songs
    }
}



