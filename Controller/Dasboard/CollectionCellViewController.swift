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
    @IBOutlet weak var titleSwitchTile: UILabel!
    @IBOutlet weak var labelTop: UILabel!
    @IBOutlet weak var labelBottom: UILabel!
    
    //Scene Tile
    @IBOutlet weak var titleSceneTile: UILabel!
    @IBOutlet weak var labelLeft: UILabel!
    @IBOutlet weak var labelRight: UILabel!
    
    //SwitchTile Tile
    @IBOutlet weak var titleSwitch: UILabel!
    
    
    //Thermostat Group
    @IBOutlet weak var titleThermoGroup: UILabel!
    @IBOutlet weak var targetTempThermoGroup: UILabel!
    @IBOutlet weak var thermosOnTarget: UILabel!
    @IBOutlet weak var thermosNotOnTarget: UILabel!
    
    //Thermostat Tile
    @IBOutlet weak var thermoTileTitle: UILabel!
    @IBOutlet weak var targetTemp: UILabel!
    @IBOutlet weak var currentTemp: UILabel!

    
    //@IBOutlet weak var titleThermostatTile: UILabel!
}

protocol CollectionCellViewControllerDelegate: class {
    func button(addNewTile cell: CollectionCellViewController)
}
