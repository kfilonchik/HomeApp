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
        

    }
    
    @IBAction func printSTT(_ sender: UIButton) {
        
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
        
        let sceSetThermos: NSFetchRequest<SceneThermostatSetting> = SceneThermostatSetting.fetchRequest()
        
        if (thermoGroups?.count == 0){

            let aThermoGroup = ThermostatGroup(context: context)
            aThermoGroup.title = "testGruppe Thermostate"

        }
        
        if (scenes?.count == 0){
            let aScene = Scene(context: context)
            aScene.title = "Testscene"
            
        }
        
        if (thermoGroups != nil)
        {
            let scenesSettings = try? context.fetch(sceSetThermos)
            for aThermo in thermos!{
                let thermoGroups = try? context.fetch(thermoGroupRequest)
                let scenes = try? context.fetch(sceneRequest)
                aThermo.addToPartOfGroups(thermoGroups![0])
                aThermo.addToPartOfScenes(scenes![0])
                
                if(scenesSettings?.count == 0){
                    let ascenesSetting = SceneThermostatSetting(context: context)
                    ascenesSetting.connectedThermostat = aThermo
                    ascenesSetting.thermostat = aThermo
                    ascenesSetting.scene = scenes![0]
                    ascenesSetting.connectedScene = scenes![0]
                    ascenesSetting.target_temp = 11.1
                }

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
        
        let sceSetSwitches: NSFetchRequest<SceneSwitchSetting> = SceneSwitchSetting.fetchRequest()
        

        if (switchGroups?.count == 0){
            let aSwitchGroup = SwitchGroup(context: context)
            aSwitchGroup.title = "Switchgroup test"
        }
        
        if (scenes?.count == 0){
            let aScene = Scene(context: context)
            aScene.title = "Testscene"

            
        }

        if (switchGroups != nil)
        {
            let scenesSettings = try? context.fetch(sceSetSwitches)
            for aSwitch in switches!{
                let switchGroups = try? context.fetch(switchGroupRequest)
                let scenes = try? context.fetch(sceneRequest)
                aSwitch.addToPartOfGroups(switchGroups![0])
                aSwitch.addToPartOfScenes(scenes![0])
                
                if(scenesSettings?.count == 0){
                    let ascenesSetting = SceneSwitchSetting(context: context)
                    ascenesSetting.connectedSwitch = aSwitch
                    ascenesSetting.connectedScene = scenes![0]
                    ascenesSetting.state = false
                    ascenesSetting.switchDevice = aSwitch
                    ascenesSetting.scene = scenes![0]
                }
                
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

