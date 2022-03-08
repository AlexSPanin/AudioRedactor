//
//  AETableViewDataSource.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import UIKit

extension AudioEngineViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dataPlayingNodes.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataPlayingNodes[section].framesForNode.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Node :\(section)"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nodeCell", for: indexPath)  as! NodeTableViewCell
        
        let frame = dataPlayingNodes[indexPath.section].framesForNode[indexPath.row]
        cell.delegate = self
        cell.configure( frame: frame, isHidingSwitch: isPlaying, indexRow: indexPath.section )
        return cell
    }
}

