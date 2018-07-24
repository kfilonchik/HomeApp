//
//  NewSceneController.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 19.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit
import CoreData

class NewSceneController: UITableViewController, UITextFieldDelegate {
    
    let context = AppDelegate.viewContext
    let switchReq: NSFetchRequest<SwitchDevice> = SwitchDevice.fetchRequest()
    let thermoReq: NSFetchRequest<Thermostat> = Thermostat.fetchRequest()
    let scenepReq: NSFetchRequest<Scene> = Scene.fetchRequest()
    
    var cellStyleForEditing: UITableViewCellEditingStyle = .none
    
    var switches: [SwitchDevice]?
    var thermos: [Thermostat]?
    var scenes: [Scene]?
    
    var data: String?
    var titel: String?
    
    func refreshData(){
        switches = try? context.fetch(switchReq)
        thermos = try? context.fetch(thermoReq)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
  
        //Get titel of Scene from Alert
        if let concreteData = data {
            titel = concreteData
        }
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return (thermos?.count)!
        case 2:
            return (switches?.count)!
        default:
            return 0
        }

   
    }
    func tableView(_ tableView: UITableView, canEditRowAtIndexPath indexPath: IndexPath) -> Bool {
        if indexPath.section == 1{
            return true
        }
        return false
        /*
         if indexPath.section == 0 {
         return true
         }
         else {
         return false
         }
         
         */
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newPrototypeCell", for: indexPath)
        
        var cellLabel: String?
        //titelCell.selectionStyle = UITableViewCellSelectionStyle.none
        switch indexPath.section{
        case 0:
            cellLabel = titel
            tableView.setEditing(cellStyleForEditing == .insert, animated: true)
            cell.textLabel?.text = cellLabel

        case 1:
            cellLabel = thermos?[indexPath.row].title
            if(thermos?[indexPath.row].onDashboard == true){cell.accessoryType = UITableViewCellAccessoryType.checkmark}
            else{cell.accessoryType = UITableViewCellAccessoryType.none}
            
        case 2:
            cellLabel = switches?[indexPath.row].title
            if(switches?[indexPath.row].onDashboard == true){cell.accessoryType = UITableViewCellAccessoryType.checkmark}
            else{cell.accessoryType = UITableViewCellAccessoryType.none}
            
        default:
            print("default in override func tableView")
        }
        cell.textLabel?.text = cellLabel
        return cell
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Title"
        case 1:
            return "Thermostats"
        case 2:
            return "Switches"
        default:
            return "Some problems!"
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section{
        case 0:
            
            tableView.setEditing(cellStyleForEditing == .insert, animated: true)

        case 1:
            if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){ // delete a tile
                thermos?[indexPath.row].onDashboard = false
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
                
            }
            else{ // create a tile
                thermos?[indexPath.row].onDashboard = true
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            do{try context.save()} catch {print(error)}
        case 2:
            if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){ // delete a tile
                switches?[indexPath.row].onDashboard = false
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            }
            else{ // create a tile
                switches?[indexPath.row].onDashboard = true
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            do{try context.save()} catch {print(error)}
       
        default:
            print("default in override func tableView")
        }
        
    }
    
}


