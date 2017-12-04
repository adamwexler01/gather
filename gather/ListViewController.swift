//
//  ListViewController.swift
//  gather
//
//  Created by Adam Wexler on 12/3/17.
//  Copyright © 2017 Gather, Inc. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Unbox

class ListViewController: UITableViewController {
    
    var events: [Event] = [] {
        didSet {
            tableView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "eventTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventTableViewCell", for: indexPath) as! EventTableViewCell
        let event = events[indexPath.row]
        cell.textLabel?.text = event.name ?? "no name found"
        
        cell.detailTextLabel?.text = "\(event.date)"
        
        return cell
    }
    
}
