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
    
    var newGrTitle: String?
    
    var receivedThermoGroup: ThermostatGroup?
    var receivedSwitchGroup: SwitchGroup?
    
    var newThermoGroup: ThermostatGroup?
    var newSwitchGroup: SwitchGroup?
    
    func refreshData(){
        switches = try? context.fetch(switchReq)
        thermos = try? context.fetch(thermoReq)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
        self.title = newGrTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if(receivedSwitchGroup == nil && receivedThermoGroup == nil){
            //print("3 Sections")
            return 3
        }
        else{
            //print("2 Sections")
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        
        case 0:
            return 1
        
        case 1:
            if(receivedThermoGroup != nil){
                //print("in ghermogroup")
                    return (thermos?.count)!
            }
            else if(receivedSwitchGroup != nil){
                //print("in swgroup")
                    return (switches?.count)!
            }
                
            else{
                //print("in else")
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //Config and select cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupPrototypeCell", for: indexPath)
        var cellLabel: String?
        switch indexPath.section{
        case 0:
            print("in Case 0")

            let aCell = tableView.dequeueReusableCell(withIdentifier: "titlePrototypeCell", for: indexPath) as! GroupTableViewCell
            cellLabel = newGrTitle
            aCell.selectionStyle = UITableViewCellSelectionStyle.none
            aCell.titleTextField.text = newGrTitle
            aCell.titleTextField.delegate = self
            return aCell

        case 1: // New Group Thermos
            print("in Case 1")
            if(receivedThermoGroup != nil){ //Views Renders a ThermoGroup
                cellLabel = thermos?[indexPath.row].title
                if(thermos?[indexPath.row].partOfGroups != nil){ //Check if member of group
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
            
            
            else if(receivedSwitchGroup != nil){ // View Renders a SwitchGroup
                cellLabel = switches?[indexPath.row].title
                if(switches?[indexPath.row].partOfGroups != nil){ //Check if member of group
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
            else{
                cellLabel = thermos?[indexPath.row].title
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
            
        case 2: // New Group Switches
            print("in Case 2")
            cell.accessoryType = UITableViewCellAccessoryType.none
            cellLabel = switches?[indexPath.row].title
            
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
            
            print("did select case 0")
            
        case 1: //Selected a thermostat
            print("did select case 1")
            
            if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){ // delete device from group
                if(receivedThermoGroup != nil){
                    thermos?[indexPath.row].removeFromPartOfGroups(receivedThermoGroup!)
                }
                else if(receivedSwitchGroup != nil){
                    switches?[indexPath.row].removeFromPartOfGroups(receivedSwitchGroup!)
                }
                
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            }
                
            else{ // add device to the group
                
                if(receivedThermoGroup != nil){
                    thermos?[indexPath.row].addToPartOfGroups(receivedThermoGroup!)
                }
                else if(receivedSwitchGroup != nil){
                    switches?[indexPath.row].addToPartOfGroups(receivedSwitchGroup!)
                }
                
                else if (receivedSwitchGroup == nil && receivedThermoGroup == nil){ //create a swich Group and deselect all other
                    print("create a new Thermostat Group")
                    
                    if (newThermoGroup == nil){
                        newThermoGroup = ThermostatGroup(context: context)
                        newThermoGroup?.title = newGrTitle
                    }
                    thermos?[indexPath.row].addToPartOfGroups(newThermoGroup!)
                    if(newSwitchGroup != nil){
                        //Show a Popup here "Groups can only contain Switches or Thermostats, use a Scene if you want to Combine"
                        context.delete(newSwitchGroup!)
                    }
                    newSwitchGroup = nil
                    let counter = tableView.numberOfRows(inSection: 2)
                    for i in 0 ... counter - 1{
                        tableView.cellForRow(at: [2,i])?.accessoryType = UITableViewCellAccessoryType.none
                    }
                }
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            
            do{try context.save()} catch {print(error)}
        
        case 2: // Selected a Switch
            print("did select case 2")
            
            if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){ // Delete from Group

                
                
                
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            }
            else{ // create a new Group and add sw
                if(newSwitchGroup == nil){
                    newSwitchGroup = SwitchGroup(context: context)
                    newSwitchGroup?.title = newGrTitle
                }
                switches?[indexPath.row].addToPartOfGroups(newSwitchGroup!)
                
                if(newThermoGroup != nil){
                    //Show a Popup here "Groups can only contain Switches or Thermostats, use a Scene if you want to Combine"
                    context.delete(newThermoGroup!)
                }
                let counter = tableView.numberOfRows(inSection: 1)
                for i in 0 ... counter - 1{
                    tableView.cellForRow(at: [1,i])?.accessoryType = UITableViewCellAccessoryType.none
                }
                
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
        print("end editing")
        var v : UIView = textField
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! GroupTableViewCell
        self.title = cell.titleTextField.text!

        receivedThermoGroup?.title = cell.titleTextField.text!
        receivedSwitchGroup?.title = cell.titleTextField.text!
        newThermoGroup?.title = cell.titleTextField.text!
        newSwitchGroup?.title = cell.titleTextField.text!
        
        do{try context.save()} catch {print(error)}
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
