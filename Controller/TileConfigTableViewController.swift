//
//  TileConfigTableViewController.swift
//  tableview
//
//  Created by Jokto on 19.07.18.
//  Copyright © 2018 MobileAnwendungen. All rights reserved.
//

import UIKit
import CoreData

class TileConfigTableViewController: UITableViewController {
    
    let context = AppDelegate.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print("didLoad")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tileSettingsCell", for: indexPath)
        
        cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            print("unset")
            print(indexPath)
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            print("set")
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Schalter"
        case 1:
            return "Thermostate"
        case 2:
            return "Gruppen: Thermostate"
        case 3:
            return "Gruppen: Schalter"
        case 4:
            return "Szenen"
        default:
            return "Fehler!"
        }

    }


}
