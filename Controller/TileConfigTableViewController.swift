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
    
    let countOfTileTypes = 5
    let context = AppDelegate.viewContext
    let defaultOrder:Int16 = 32767
    let switchReq: NSFetchRequest<SwitchDevice> = SwitchDevice.fetchRequest()
    let thermoReq: NSFetchRequest<Thermostat> = Thermostat.fetchRequest()
    let switchGroupReq: NSFetchRequest<SwitchGroup> = SwitchGroup.fetchRequest()
    let thermoGroupReq: NSFetchRequest<ThermostatGroup> = ThermostatGroup.fetchRequest()
    let scenepReq: NSFetchRequest<Scene> = Scene.fetchRequest()
    

    var switches: [SwitchDevice]?
    var thermos: [Thermostat]?
    var switchGroups: [SwitchGroup]?
    var thermoGroups: [ThermostatGroup]?
    var scenes: [Scene]?


    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
    }
    
    func refreshData(){
        switches = try? context.fetch(switchReq)
        thermos = try? context.fetch(thermoReq)
        switchGroups = try? context.fetch(switchGroupReq)
        thermoGroups = try? context.fetch(thermoGroupReq)
        scenes = try? context.fetch(scenepReq)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return (switches?.count)!
        case 1:
            return (thermos?.count)!
        case 2:
            return (switchGroups?.count)!
        case 3:
            return (thermoGroups?.count)!
        case 4:
            return (scenes?.count)!
        default:
            return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return countOfTileTypes
        //add code to not show sections if no items in it
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tileSettingsCell", for: indexPath)
        var cellLabel: String?
        switch indexPath.section{
        case 0:
            cellLabel = switches?[indexPath.row].title
            if(switches?[indexPath.row].onDashboard == true){cell.accessoryType = UITableViewCellAccessoryType.checkmark}
            else{cell.accessoryType = UITableViewCellAccessoryType.none}

        case 1:
            cellLabel = thermos?[indexPath.row].title
            if(thermos?[indexPath.row].onDashboard == true){cell.accessoryType = UITableViewCellAccessoryType.checkmark}
            else{cell.accessoryType = UITableViewCellAccessoryType.none}
            
        case 2:
            cellLabel = switchGroups?[indexPath.row].title
            if(switchGroups?[indexPath.row].onDashboard == true){cell.accessoryType = UITableViewCellAccessoryType.checkmark}
            else{cell.accessoryType = UITableViewCellAccessoryType.none}

        case 3:
            cellLabel = thermoGroups?[indexPath.row].title
            if(thermoGroups?[indexPath.row].onDashboard == true){cell.accessoryType = UITableViewCellAccessoryType.checkmark}
            else{cell.accessoryType = UITableViewCellAccessoryType.none}

        case 4:
            cellLabel = scenes?[indexPath.row].title
            if(scenes?[indexPath.row].onDashboard == true){cell.accessoryType = UITableViewCellAccessoryType.checkmark}
            else{cell.accessoryType = UITableViewCellAccessoryType.none}

        default:
            print("default in override func tableView")
        }
        cell.textLabel?.text = cellLabel
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.section{
        case 0:
            if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){ // delete a tile
                switches?[indexPath.row].onDashboard = false
                switches?[indexPath.row].order = defaultOrder
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            }
            else{ // create a tile
                switches?[indexPath.row].onDashboard = true
                switches?[indexPath.row].order = getNextOrder()
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            do{try context.save()} catch {print(error)}
        
        case 1:
            if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){ // delete a tile
                thermos?[indexPath.row].onDashboard = false
                thermos?[indexPath.row].order = defaultOrder
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            }
            else{ // create a tile
                thermos?[indexPath.row].onDashboard = true
                thermos?[indexPath.row].order = getNextOrder()
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            do{try context.save()} catch {print(error)}
        
        case 2:
            if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){ // delete a tile
                switchGroups?[indexPath.row].onDashboard = false
                switchGroups?[indexPath.row].order = defaultOrder
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            }
            else{ // create a tile
                switchGroups?[indexPath.row].onDashboard = true
                switchGroups?[indexPath.row].order = getNextOrder()
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            do{try context.save()} catch {print(error)}
        
        case 3:
            if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){ // delete a tile
                thermoGroups?[indexPath.row].onDashboard = false
                thermoGroups?[indexPath.row].order = defaultOrder
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
                
            }
            else{ // create a tile
                thermoGroups?[indexPath.row].onDashboard = true
                thermoGroups?[indexPath.row].order = getNextOrder()
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            do{try context.save()} catch {print(error)}
        
        case 4:
            if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){ // delete a tile
                scenes?[indexPath.row].onDashboard = false
                scenes?[indexPath.row].order = defaultOrder
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            }
            else{ // create a tile
                scenes?[indexPath.row].onDashboard = true
                scenes?[indexPath.row].order = getNextOrder()
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
            return "Schalter"
        case 1:
            return "Thermostate"
        case 2:
            return "Gruppen: Schalter"
        case 3:
            return "Gruppen: Thermostate"
        case 4:
            return "Szenen"
        default:
            return "Fehler!"
        }

    }
    
    func getNextOrder()->Int16{

        let findMaxReq: NSFetchRequest<DashboardTile> = DashboardTile.fetchRequest()
        findMaxReq.predicate = NSPredicate(format: "onDashboard == true")
        let sort = NSSortDescriptor(key: #keyPath(DashboardTile.order), ascending: true)
        findMaxReq.sortDescriptors = [sort]
        let tiles = try? context.fetch(findMaxReq)
        var order:Int16 = 0
        
        for aTile in tiles!{ // reorder to fill possible gaps
            aTile.order = order
            order += 1
        }
        
        

        var lastTileOrder:Int16 = 0
            
        if(tiles?.count != nil){
            lastTileOrder = Int16(tiles!.count) - 1
        }
        return lastTileOrder
    }
}

