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

    
    @IBAction func NewGroup(_ sender: UIButton) {
    }

    @IBAction func DeleteGroup(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "GroupThermostat", bundle: nil), forCellReuseIdentifier: "GroupThermostat")
        tableView.register(UINib(nibName: "GroupSwitch", bundle: nil), forCellReuseIdentifier: "GroupSwitch")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let groupThermostatRequest: NSFetchRequest<ThermostatGroupTile> = ThermostatGroupTile.fetchRequest()
        let groupsThermostat = try? context.fetch(groupThermostatRequest)
        
        let groupSwitchRequest: NSFetchRequest<SwitchGroupTile> = SwitchGroupTile.fetchRequest()
        let groupsSwitch = try? context.fetch(groupSwitchRequest)
        
        
        
        if section == 0 {
            return groupsThermostat!.count
            
        }
   
        if section == 1 {
            return groupsSwitch!.count
           
        }

        return super.tableView(tableView, numberOfRowsInSection: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let groupThermostatRequest: NSFetchRequest<ThermostatGroupTile> = ThermostatGroupTile.fetchRequest()
        let groupsThermostat = try? context.fetch(groupThermostatRequest)
        
        let groupSwitchRequest: NSFetchRequest<SwitchGroupTile> = SwitchGroupTile.fetchRequest()
        let groupsSwitch = try? context.fetch(groupSwitchRequest)
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupThermostat") as! GroupTableViewCell
        cell.GroupTitleThermostat.text = groupsThermostat?[indexPath.item].title
            
          //  cell.GroupTitleThermostat.text = "test"
            return cell
        }
       
       if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupSwitch") as! GroupTableViewCell
            cell.GroupTitleSwitch.text = groupsSwitch?[indexPath.item].title
            
            //cell.GroupTitleSwitch.text = "test2"
            return cell
        }

        return super.tableView(tableView, cellForRowAt: indexPath)
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
            return 44
        }
        if indexPath.section == 1 {
            return 44
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
}
