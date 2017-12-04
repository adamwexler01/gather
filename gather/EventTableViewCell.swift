//
//  EventTableViewCell.swift
//  gather
//
//  Created by Adam Wexler on 12/3/17.
//  Copyright © 2017 Gather, Inc. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
