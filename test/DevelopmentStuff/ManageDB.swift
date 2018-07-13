//
//  ManageDB.swift
//  Domovoi
//
//  Created by Jokto on 29.06.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ManageDB: UIViewController {

    let context = AppDelegate.viewContext
    let aConnector = Connector()
    //let container = AppDelegate.persistentContainer

    
    override func viewDidLoad() {
        super.viewDidLoad()
        aConnector.startUpConnector()
    }

    @IBAction func addWrongData(_ sender: UIButton) {
        let stdAppSettings = AppSettings(context: context)
        stdAppSettings.fritzID = "rtzrtz"
        stdAppSettings.userName = "rtzrtz"
        stdAppSettings.passWord = "rtztzr"
        
        do{ // persist data
            try context.save()
            
        } catch {
            print(error)
        }
    }
    
    @IBAction func printBtn(_ sender: UIButton) {
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        let result = try? context.fetch(fetchRequest)

        print(result![0].fritzID)
        print(result![0].userName)
        print(result![0].passWord)

        /*
        do{ // persist data
            try context.save()
            
        } catch {
            print(error)
        }
 */
        
    }
    
    @IBAction func deleteContentBtn(_ sender: UIButton) {
        deleteAppSettings()
    }
    
    func deleteAppSettings(){
        print("delete procedure")
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(batchDeleteRequest)
            
        } catch {
            // Error Handling
        }
        context.reset()
    }
    
    @IBAction func addDevices(_ sender: UIButton) {
        
        let switchRequest: NSFetchRequest<SwitchDevice> = SwitchDevice.fetchRequest()
        let switches = try? context.fetch(switchRequest)
        
        let thermosRequest: NSFetchRequest<Thermostat> = Thermostat.fetchRequest()
        let thermos = try? context.fetch(thermosRequest)
        

        
        if (switches != nil)
        {
            for aswitch in switches!{
                let aswitchTile = SwitchTile(context: context)
                aswitch.tile = aswitchTile
                aswitchTile.switchDevice = aswitch
            }
        }
        
        if (thermos != nil)
        {
            for athermo in thermos!{
                let aThermoTile = ThermostatTile(context: context)
                athermo.tile = aThermoTile
                aThermoTile.thermostat = athermo
            }
        }
        
        do{ // persist data
            try context.save()
            
        } catch {
            print(error)
        }
        print("Alle Devices zu Kacheln erstellt")
        
    }
    
    @IBAction func removeDevices(_ sender: UIButton) {
        
        print("delete procedure")
        let fetchRequest: NSFetchRequest<SwitchTile> = SwitchTile.fetchRequest()
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(batchDeleteRequest)
            
        } catch {
            // Error Handling
        }
        context.reset()
        
        let fetchRequest2: NSFetchRequest<ThermostatTile> = ThermostatTile.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2 as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(batchDeleteRequest2)
            
        } catch {   
            // Error Handling
        }
        context.reset()
        
    }
    
    @IBAction func printSTT(_ sender: UIButton) {
        
        let switchTilesRequest: NSFetchRequest<SwitchTile> = SwitchTile.fetchRequest()
        let switchTiles = try? context.fetch(switchTilesRequest)
        
        print("Anzahl Kacheln switches \(switchTiles!.count)")
      
        
        for bla in switchTiles!{
            print("Eine Kachel mit Switch: \(bla.switchDevice?.title)")
        }
        
        let thermoTilesRequest: NSFetchRequest<ThermostatTile> = ThermostatTile.fetchRequest()
        let thermoTiles = try? context.fetch(thermoTilesRequest)
        
        print("Anzahl Kacheln thermostate \(thermoTiles!.count)")
        
        for bla in thermoTiles!{
            print("Eine Kachel mit Thermostat:  \(bla.thermostat?.title)")
        }
        
        /*
        let switchesRequest: NSFetchRequest<SwitchDevice> = SwitchDevice.fetchRequest()
        let switches = try? context.fetch(switchesRequest)
        
        for bla in switches!{
            print("Ein Switch: \(bla.tile?.title)")
        }
        let thermosRequest: NSFetchRequest<Thermostat> = Thermostat.fetchRequest()
        let thermos = try? context.fetch(thermosRequest)
        
        for bla in thermos!{
            print("Ein Thermostat: \(bla.tile?.title)")
        }
        */
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

