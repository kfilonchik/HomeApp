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


    
    override func viewDidLoad() {
        super.viewDidLoad()
        aConnector.startUpConnector()
    }

    @IBAction func addWrongData(_ sender: UIButton) {
        let stdAppSettings = AppSettings(context: context)
        stdAppSettings.fritzID = "7ncvvd2irftxy2fv"
        stdAppSettings.userName = "domovoi"
        stdAppSettings.passWord = "DomoSafe2018!"
        
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
        
    }
    
    @IBAction func deleteContentBtn(_ sender: UIButton) {
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
    
    @IBAction func deleteAllDevices(_ sender: UIButton) {
        deleteThermos()
        deleteSwitches()
    }
    func deleteThermos(){
    print("delete procedure thermostats")
    let fetchRequest: NSFetchRequest<Thermostat> = Thermostat.fetchRequest()
        
    // Create Batch Delete Request
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
    do {
    try context.execute(batchDeleteRequest)
    
    } catch {
    // Error Handling
    }
    context.reset()
    
    }

    func deleteSwitches(){
    print("delete procedure switches")
    let fetchRequest2: NSFetchRequest<SwitchDevice> = SwitchDevice.fetchRequest()
    
    // Create Batch Delete Request
    let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2 as! NSFetchRequest<NSFetchRequestResult>)
    do {
    try context.execute(batchDeleteRequest2)
    
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
                aswitchTile.switchDevice = aswitch
            }
        }
        
        if (thermos != nil)
        {
            for athermo in thermos!{
                let aThermoTile = ThermostatTile(context: context)
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
        
        
        let switchesRequest: NSFetchRequest<SwitchDevice> = SwitchDevice.fetchRequest()
        let switches = try? context.fetch(switchesRequest)
        
        for bla in switches!{
            print("Ein SwitchDevice: \(bla.title)")
        }
        let thermosRequest: NSFetchRequest<Thermostat> = Thermostat.fetchRequest()
        let thermos = try? context.fetch(thermosRequest)
        
        for bla in thermos!{
            print("Ein ThermostatDEvice: \(bla.title)")
        }
        
        
    }
    
    @IBAction func relaodDevices(_ sender: UIButton) {
        aConnector.getAllDevices()
    }
    
    @IBAction func addThermosToGroupBtn(_ sender: UIButton) {
        
        let thermoGroupRequest: NSFetchRequest<ThermostatGroup> = ThermostatGroup.fetchRequest()
        let thermoGroups = try? context.fetch(thermoGroupRequest)
        
        let thermosRequest: NSFetchRequest<Thermostat> = Thermostat.fetchRequest()
        let thermos = try? context.fetch(thermosRequest)
        
        let sceneRequest: NSFetchRequest<Scene> = Scene.fetchRequest()
        let scenes = try? context.fetch(sceneRequest)
        
        let sceneTileReq: NSFetchRequest<SceneTile> = SceneTile.fetchRequest()
        let sceneTiles = try?context.fetch(sceneTileReq)
        
        let thermoGroupTileReq: NSFetchRequest<ThermostatGroupTile> = ThermostatGroupTile.fetchRequest()
        let thermoGroupTiles = try?context.fetch(thermoGroupTileReq)
        
        if(thermoGroupTiles?.count == 0){
            let athermoGroupTile = ThermostatGroupTile(context: context)
            athermoGroupTile.title = "test tile thermo Group"
        }
        
        if(sceneTiles?.count == 0){
            let aSceneTile = SceneTile(context: context)
            aSceneTile.title = "test Scene tile"
        }
        
        if (thermoGroups?.count == 0){
            let thermoGroupTiles = try?context.fetch(thermoGroupTileReq)
            let aThermoGroup = ThermostatGroup(context: context)
            aThermoGroup.title = "Test Group Thermo"
            aThermoGroup.tile = thermoGroupTiles![0]
        }
        
        if (scenes?.count == 0){
            let aScene = Scene(context: context)
            aScene.title = "Testscene"
            let sceneTiles = try?context.fetch(sceneTileReq)
            aScene.tile = sceneTiles![0]
            
        }
        
        if (thermoGroups != nil)
        {
            for aThermo in thermos!{
                let thermoGroups = try? context.fetch(thermoGroupRequest)
                let scenes = try? context.fetch(sceneRequest)
                aThermo.addToPartOfGroups(thermoGroups![0])
                aThermo.addToPartOfScenes(scenes![0])
            }
        }
        
        do{ // persist data
            try context.save()
            
        } catch {
            print(error)
        }
    }

    @IBAction func addSwitchesToGroupSceneBtn(_ sender: UIButton) {
        
        let switchGroupRequest: NSFetchRequest<SwitchGroup> = SwitchGroup.fetchRequest()
        let switchGroups = try? context.fetch(switchGroupRequest)
        
        let switchRequest: NSFetchRequest<SwitchDevice> = SwitchDevice.fetchRequest()
        let switches = try? context.fetch(switchRequest)
        
        let sceneRequest: NSFetchRequest<Scene> = Scene.fetchRequest()
        let scenes = try? context.fetch(sceneRequest)
        
        let sceneTileReq: NSFetchRequest<SceneTile> = SceneTile.fetchRequest()
        let sceneTiles = try?context.fetch(sceneTileReq)
        
        let switchGroupTileReq: NSFetchRequest<SwitchGroupTile> = SwitchGroupTile.fetchRequest()
        let switchGroupTiles = try?context.fetch(switchGroupTileReq)
        
        if(switchGroupTiles?.count == 0){
            let aSwitchGroupTile = SwitchGroupTile(context: context)
            aSwitchGroupTile.title = "test tile switch Group"
        }
        
        
        if(sceneTiles?.count == 0){
            let aSceneTile = SceneTile(context: context)
            aSceneTile.title = "test Scene tile"
        }
        
        if (switchGroups?.count == 0){
            let switchGroupTiles = try?context.fetch(switchGroupTileReq)
            let aSwitchGroup = SwitchGroup(context: context)
            aSwitchGroup.title = "Switchgroup test"
            aSwitchGroup.tile = switchGroupTiles?[0]
        }
        
        if (scenes?.count == 0){
            let aScene = Scene(context: context)
            aScene.title = "Testscene"
            let sceneTiles = try?context.fetch(sceneTileReq)
            aScene.tile = sceneTiles![0]
            
        }

        if (switchGroups != nil)
        {
            for aSwitch in switches!{
                let switchGroups = try? context.fetch(switchGroupRequest)
                let scenes = try? context.fetch(sceneRequest)
                aSwitch.addToPartOfGroups(switchGroups![0])
                aSwitch.addToPartOfScenes(scenes![0])
            }
        }
        
        
        
        do{ // persist data
            try context.save()
            
        } catch {
            print(error)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

