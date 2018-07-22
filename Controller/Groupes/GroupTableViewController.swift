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

   
    @IBAction func newGroup(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Give a title for your group", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your name here..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                print("Title: \(name)")
                self.performSegue(withIdentifier: "NewGroup", sender: self)
                
                
            }
        }))
        
        self.present(alert, animated: true)
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let groupThermostatRequest: NSFetchRequest<ThermostatGroup> = ThermostatGroup.fetchRequest()
        let groupsThermostat = try? context.fetch(groupThermostatRequest)
        
        let groupSwitchRequest: NSFetchRequest<SwitchGroup> = SwitchGroup.fetchRequest()
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
        
        let groupThermostatRequest: NSFetchRequest<ThermostatGroup> = ThermostatGroup.fetchRequest()
        let groupsThermostat = try? context.fetch(groupThermostatRequest)
        
        let groupSwitchRequest: NSFetchRequest<SwitchGroup> = SwitchGroup.fetchRequest()
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
