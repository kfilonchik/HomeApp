//
//  DeleteGroupController.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 19.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit
import CoreData

class DeleteGroupController: UITableViewController {
    let context = AppDelegate.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "deleteCell") as! DeleteGroupCell
            cell.DeleteGroupTitle.text = groupsThermostat?[indexPath.item].title
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "deleteCell") as! DeleteGroupCell
            cell.DeleteGroupTitle.text = groupsSwitch?[indexPath.item].title
            
            return cell
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }

}
