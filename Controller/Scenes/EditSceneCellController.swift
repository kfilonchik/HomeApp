//
//  EditSceneCellController.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 29.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit

class EditSceneCellController: UITableViewCell {
    
    @IBOutlet weak var titleOfScene: UILabel!
    
    @IBOutlet weak var titleThermostat: UILabel!
    
    @IBOutlet weak var actualTemp: UILabel!
    
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var titleSwitch: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
