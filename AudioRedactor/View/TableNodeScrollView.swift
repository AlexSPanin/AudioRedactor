//
//  TableNodeScrollView.swift
//  AudioRedactor
//
//  Created by Александр Панин on 08.03.2022.
//

import UIKit

class TableNodeScrollView: UIScrollView {
    
    var tableView: UITableView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureTableView()
    }
    
    func setTableView(to table: UITableView) {
        tableView = table
        configureTableView()
    }
    
private func configureTableView() {
        
        guard let tableView = tableView else { return }

        self.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
}
