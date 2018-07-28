//
//  SceneCell.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 19.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit

class SceneCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var SceneCellTitle: UILabel!
    /*
    override func didTransition(to state: UITableViewCellStateMask) {
        self.titleTextField.isEnabled = state.contains(.showingEditControlMask)
        super.didTransition(to:state)
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  

}
