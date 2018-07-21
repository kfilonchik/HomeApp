//
//  CollectionCellViewControllerCollectionViewCell.swift
//  test
//
//  Created by Khristina Filonchik on 15.06.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit

class CollectionCellViewController: UICollectionViewCell {
   weak var delegate: CollectionCellViewControllerDelegate?
    
    @IBAction func makeNewTile(_ sender: Any) {
        delegate?.button(addNewTile: self)
    }
    
    //SwitchGroup
    @IBOutlet weak var titleSwitchGroup: UILabel!
    @IBOutlet weak var labelTop: UILabel!
    @IBOutlet weak var labelBottom: UILabel!
    
    //Scene
    @IBOutlet weak var titleSceneTile: UILabel!
    @IBOutlet weak var labelLeft: UILabel!
    @IBOutlet weak var labelRight: UILabel!
    
    //Switch
    @IBOutlet weak var titleSwitch: UILabel!
    
    
    //Thermostat Group
    @IBOutlet weak var titleThermoGroup: UILabel!
    @IBOutlet weak var targetTempThermoGroup: UILabel!
    @IBOutlet weak var thermosOnTarget: UILabel!
    @IBOutlet weak var thermosNotOnTarget: UILabel!
    
    //Thermostat
    @IBOutlet weak var thermoTileTitle: UILabel!
    @IBOutlet weak var targetTemp: UILabel!
    @IBOutlet weak var currentTemp: UILabel!

}

protocol CollectionCellViewControllerDelegate: class {
    func button(addNewTile cell: CollectionCellViewController)
}
