//
//  AudiobookTableOfContentsTableViewController.swift
//  NYPLAudiobookToolkit
//
//  Created by Dean Silfen on 2/22/18.
//  Copyright © 2018 Dean Silfen. All rights reserved.
//

import UIKit

class AudiobookTableOfContentsTableViewController: UITableViewController, AudiobookTableOfContentsDataSourceDelegate {

    func audiobookTableOfContentsDataSourceDidRequestReload(_ audiobookTableOfContentsDataSource: AudiobookTableOfContentsDataSource) {
        self.tableView.reloadData()
    }

    let dataSource: AudiobookTableOfContentsDataSource
    public init(dataSource: AudiobookTableOfContentsDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
        self.title = "Table Of Contents"
        self.dataSource.delegate = self
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self.dataSource
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
