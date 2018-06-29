//
//  SettingsTableViewCell.swift
//  test
//
//  Created by Khristina Filonchik on 31.05.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    var inSettings: InSettings? {
        didSet {
            guard let inSettings = inSettings else { return }
            nameLabel.text = inSettings.name
           
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
