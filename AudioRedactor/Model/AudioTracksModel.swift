//
//  AudioTracksModel.swift
//  AudioRedactor
//
//  Created by Александр Панин on 11.03.2022.
//

import AVFAudio

class AudioTracksModel {
    
    var trackForTracks = [AudioTrackModel()]

    var currentSecTime: Double = 0                            // текущая позиция проигрования в треке в секундах
    var lengthSecTime: Double = 0                             // длина узла изначально равна сумме длин фрэймов в секундах
 
}
