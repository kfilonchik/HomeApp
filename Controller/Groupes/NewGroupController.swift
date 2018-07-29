//
//  NewGroupController.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 20.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit
import CoreData

class NewGroupController: UITableViewController,  UITextFieldDelegate  {
    
    let context = AppDelegate.viewContext
    let switchReq: NSFetchRequest<SwitchDevice> = SwitchDevice.fetchRequest()
    let thermoReq: NSFetchRequest<Thermostat> = Thermostat.fetchRequest()
    
    
    var switches: [SwitchDevice]?
    var thermos: [Thermostat]?
    
    var newGrTitle: String? // Remove
    var titel:String?
    
    var receivedThermoGroup: ThermostatGroup?
    var receivedSwitchGroup: SwitchGroup?
    
    func refreshData(){
        switches = try? context.fetch(switchReq)
        thermos = try? context.fetch(thermoReq)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
           refreshData()
        
        if let concreteData = newGrTitle {
            titel = concreteData
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if(receivedSwitchGroup == nil && receivedThermoGroup == nil){
            print("3 Sections")
            return 3
        }
        else{
            print("1 Sections")
            return 1
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        
        case 0:
            if(receivedThermoGroup != nil){
                print("in ghermogroup")
                return (thermos?.count)!
            }
            else if(receivedSwitchGroup != nil){
                print("in swgroup")
                return (switches?.count)!
            }
            else{return 1}
        case 1:
            
            if(receivedThermoGroup != nil){
                print("in ghermogroup")
                    return (thermos?.count)!
            }
            else if(receivedSwitchGroup != nil){
                print("in swgroup")
                    return (switches?.count)!
                
            }
            else{
                print("in else")
                return (thermos?.count)!
                
            }
            
            
        case 2:
            return (switches?.count)!
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
            return .none
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupPrototypeCell", for: indexPath)
        var cellLabel: String?
        switch indexPath.section{
        case 0:
            if(receivedThermoGroup == nil && receivedSwitchGroup == nil){ //create new group case
                let aCell = tableView.dequeueReusableCell(withIdentifier: "titlePrototypeCell", for: indexPath) as! GroupTableViewCell
                cellLabel = titel
                aCell.selectionStyle = UITableViewCellSelectionStyle.none
                aCell.titleTextField.text = self.titel
                aCell.titleTextField.delegate = self
                return aCell
            }
            
            if(receivedThermoGroup != nil){ //Views Renders a ThermoGroup
                cellLabel = thermos?[indexPath.row].title
                if(thermos?[indexPath.row].partOfGroups != nil){ //Check if member of Group
                    let allGroups = thermos?[indexPath.row].partOfGroups
                    cell.accessoryType = UITableViewCellAccessoryType.none
                    for aGroup in allGroups!{
                        let acastedGroup = aGroup as? ThermostatGroup
                        if (acastedGroup == receivedThermoGroup){
                            cell.accessoryType = UITableViewCellAccessoryType.checkmark
                        }
                    }
                }
            }
            
            
            if(receivedSwitchGroup != nil){ // View Renders a SwitchGroup
                cellLabel = switches?[indexPath.row].title
                if(switches?[indexPath.row].partOfGroups != nil){ //Check if member of Group
                    let allGroups = switches?[indexPath.row].partOfGroups
                    cell.accessoryType = UITableViewCellAccessoryType.none
                    for aGroup in allGroups!{
                        let acastedGroup = aGroup as? SwitchGroup
                        if (acastedGroup == receivedSwitchGroup){
                            cell.accessoryType = UITableViewCellAccessoryType.checkmark
                        }
                    }
                }
            }


            
        case 1: // New Group Thermos
            print("in Case 1")
            cellLabel = thermos?[indexPath.row].title
            cell.accessoryType = UITableViewCellAccessoryType.none

            //if(thermos?[indexPath.row].onDashboard == true){cell.accessoryType = UITableViewCellAccessoryType.checkmark}
            //else{cell.accessoryType = UITableViewCellAccessoryType.none}
            
        case 2: // New Group Switches
            print("in Case 2")
            cell.accessoryType = UITableViewCellAccessoryType.none
            cellLabel = switches?[indexPath.row].title
            
            //if(switches?[indexPath.row].onDashboard == true){cell.accessoryType = UITableViewCellAccessoryType.checkmark}
            //else{cell.accessoryType = UITableViewCellAccessoryType.none}
            
        default:
            print("default in override func tableView")
        }
        cell.textLabel?.text = cellLabel
        return cell
        
    }



    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
             return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section{
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupPrototypeCell", for: indexPath)
            cell.setEditing(true, animated: true)
            
            cell.textLabel?.text = titel
            
            do{try context.save()} catch {print(error)}
            
        case 1:
            if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){ // delete a tile
                //thermos?[indexPath.row].onDashboard = false
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
                
            }
            else{ // create a tile
                //thermos?[indexPath.row].onDashboard = true
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            do{try context.save()} catch {print(error)}
        
        case 2:
            if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){ // delete a tile
                //switches?[indexPath.row].onDashboard = false
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            }
            else{ // create a tile
                //switches?[indexPath.row].onDashboard = true
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            do{try context.save()} catch {print(error)}
            
        default:
            print("default in override func tableView")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if(receivedSwitchGroup == nil && receivedThermoGroup == nil){}
            return "Title"
        case 1:
            return "Thermostats"
        case 2:
            return "Switches"
        default:
            return "Some problems!"
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        // some cell's text field has finished editing; which cell?
        var v : UIView = textField
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! GroupTableViewCell
        // what row is that?
        let ip = self.tableView.indexPath(for:cell)!
        // update data model to match
        if ip.section == 0 {
            self.title = cell.titleTextField.text!
        } else if ip.section == 0 {
            self.title = cell.titleTextField.text!
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the newGrTitle source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
