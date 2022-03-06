//
//  SongModel.swift
//  AudioRedactor
//
//  Created by Александр Панин on 04.03.2022.
//

import Foundation

enum Format: String {
    case mp3 = "mp3"
    case m4a = "m4a"
}

class SongModel {
    var name: String = ""
    var format: String = ""
}
