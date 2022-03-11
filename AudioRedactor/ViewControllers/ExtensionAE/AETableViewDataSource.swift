//
//  AETableViewDataSource.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import UIKit

extension AudioEngineViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataPlayingTracks.trackForTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nodeCell", for: indexPath)  as! NodeTableViewCell
        
        let frames = dataPlayingTracks.trackForTracks[indexPath.row].framesForTrack
        cell.delegate = self
        cell.configure(frames: frames, index: indexPath.row, currentTime: dataPlayingTracks.currentSecTime, lengthTime: dataPlayingTracks.lengthSecTime)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Tracks"
    }

}

