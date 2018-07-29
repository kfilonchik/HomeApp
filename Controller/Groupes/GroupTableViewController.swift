//
//  GroupTableViewController.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 19.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit
import CoreData

class GroupTableViewController: UITableViewController {
    let context = AppDelegate.viewContext
    
    let groupThermostatRequest: NSFetchRequest<ThermostatGroup> = ThermostatGroup.fetchRequest()
    let groupSwitchRequest: NSFetchRequest<SwitchGroup> = SwitchGroup.fetchRequest()
    
    var groupsSwitch: [SwitchGroup]?
    var groupsThermostat: [ThermostatGroup]?
    
    var titleOfNewGroup: String?
    var switchGrToTransfer: SwitchGroup?
    var thermoGrToTransfer: ThermostatGroup?
    let rowHeight:CGFloat = 44
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("in Will appear")
        refreshData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GroupThermostat", bundle: nil), forCellReuseIdentifier: "GroupThermostat")
        tableView.register(UINib(nibName: "GroupSwitch", bundle: nil), forCellReuseIdentifier: "GroupSwitch")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshData(){
        print("In refresh Data")
        groupsSwitch = try? context.fetch(groupSwitchRequest)
        groupsThermostat = try? context.fetch(groupThermostatRequest)
    }

   
    @IBAction func newGroup(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Give a title for your group", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "new Group name"
        })
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                print("Title: \(name)")
                self.titleOfNewGroup = name
            }
            self.performSegue(withIdentifier: "NewGroup", sender: self)
        }))
        self.present(alert, animated: true)
    }
    
    //last befpore seg
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewGroup" {
            //print("in seg NewGroup")
            let newGroupViewController = segue.destination as? NewGroupController
            if let svc = newGroupViewController {
                svc.newGrTitle = titleOfNewGroup
            }
        }
            
        else if segue.identifier == "editFirstCell" { // Thermostat
            //print("in seg Thermo")
            let newGroupViewController = segue.destination as? NewGroupController
                if let svc = newGroupViewController {
                    svc.newGrTitle = titleOfNewGroup
                    svc.receivedThermoGroup = thermoGrToTransfer
            }
        }
            
        else if segue.identifier == "editSecondCell" { // Switch
            let newGroupViewController = segue.destination as? NewGroupController
            //print("in seg Switch")
            if let svc = newGroupViewController {
                svc.newGrTitle = titleOfNewGroup
                svc.receivedSwitchGroup = switchGrToTransfer
            }
        }
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        refreshData()
        if section == 0 {
            return (groupsThermostat?.count)!
        }
   
        if section == 1 {
            return (groupsSwitch?.count)!
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        refreshData()
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupThermostat") as! GroupTableViewCell
         cell.GroupTitleThermostat.text = groupsThermostat?[indexPath.item].title
            return cell
        }
       
       if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupSwitch") as! GroupTableViewCell
            cell.GroupTitleSwitch.text = groupsSwitch?[indexPath.item].title
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    
    
    //wird zuerst aufgerufen
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { // Thermo Group
            //print("in prepare th")
            //let cell = tableView.dequeueReusableCell(withIdentifier: "GroupThermostat") as! GroupTableViewCell
            self.titleOfNewGroup = groupsThermostat?[indexPath.row].title
            thermoGrToTransfer = groupsThermostat?[indexPath.row]
            self.performSegue(withIdentifier: "editFirstCell", sender: self)
            
        } else if indexPath.section == 1 { //SwitchGroup
            //print("in prepare Sw")
            //let cell = tableView.dequeueReusableCell(withIdentifier: "GroupSwitch") as! GroupTableViewCell
            self.titleOfNewGroup = groupsSwitch?[indexPath.row].title
            switchGrToTransfer = groupsSwitch?[indexPath.row]
            self.performSegue(withIdentifier: "editSecondCell", sender: self)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath:IndexPath) -> Int {
        if indexPath.section == 0 {
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }
        if indexPath.section == 1 {
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath as IndexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0  {
            return rowHeight
        }
        if indexPath.section == 1 {
            return rowHeight
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                print("in Delete 0")
                context.delete(groupsThermostat![indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            } else {
                print("in Delete else")
                context.delete(groupsSwitch![indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            do{try context.save()} catch {print(error)}
        }
    }
}
