//
//  AETableViewDataSource.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import UIKit

extension AudioEngineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPlayingNodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nodeCell", for: indexPath)  as! NodeTableViewCell
        
        let data = dataPlayingNodes[indexPath.row]
        
        cell.configure( data: data, isHidingSwitch: isPlaying, indexRow: indexPath.row )
        cell.delegate = self
        return cell
    }
}

