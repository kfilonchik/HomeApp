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
    var connectedEntity: DashboardTile?

    //For Tiles elements
    @IBOutlet weak var uiSwitchOfScene: UISwitch!
    @IBOutlet weak var uiStatusOfScene: UIImageView!
    
    @IBOutlet weak var uiImageOfThermostatGroup: UIImageView!
    
    @IBOutlet weak var uiImageOfTileSwitchGroup: UIImageView!
    
    @IBAction func makeNewTile(_ sender: Any) {
        delegate?.plusButton(addNewTile: self)
    }
    
    @IBAction func toFaderButtonGroup(_ sender: Any) {
        delegate?.goToFader(entityToFade: connectedEntity!)
    }
    
    @IBAction func toFaderButtonThermo(_ sender: Any) {
        delegate?.goToFader(entityToFade: connectedEntity!)
    }
    
    @IBAction func switchSwitch(_ sender: UISwitch) {
        delegate?.switchUsed(switchedEntity: connectedEntity!, state: sender.isOn)
    }
    @IBAction func switchGroupSwitch(_ sender: UISwitch) {
        delegate?.switchUsed(switchedEntity: connectedEntity!, state: sender.isOn)
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
    func plusButton(addNewTile cell: CollectionCellViewController)
    func switchUsed(switchedEntity: DashboardTile, state: Bool)
    func goToFader(entityToFade: DashboardTile)
}
