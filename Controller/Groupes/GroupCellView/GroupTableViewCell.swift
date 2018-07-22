//
//  GroupCellControllerTableViewCell.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 19.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var GroupTitleThermostat: UILabel!
    
    @IBOutlet weak var GroupTitleSwitch: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
