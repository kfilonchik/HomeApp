//
//  EditSceneController.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 29.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit
import CoreData

class EditSceneController: UITableViewController {
    
    var data: String?
    var viewControllerTitle: String?
    var receivedScene: Scene?
    var theTableView: UITableView?
    
    let context = AppDelegate.viewContext
    
    let switchReq: NSFetchRequest<SwitchDevice> = SwitchDevice.fetchRequest()
    let thermoReq: NSFetchRequest<Thermostat> = Thermostat.fetchRequest()
    let scenSetThermosReq: NSFetchRequest<SceneThermostatSetting> = SceneThermostatSetting.fetchRequest()
    let scenSetSwitchesReq: NSFetchRequest<SceneSwitchSetting> = SceneSwitchSetting.fetchRequest()
    //let sceneReq: NSFetchRequest<Scene> = Scene.fetchRequest()
    
    var switches: [SwitchDevice]?
    var switchesFilter: [SwitchDevice] = []
    var thermos: [Thermostat]?
    var thermosFilter: [Thermostat] = []
    var scenSetThermos: [SceneThermostatSetting]?
    var scenSetSwitches: [SceneSwitchSetting]?
    
    @IBAction func goToMainPage(_ sender: UIBarButtonItem) {
         self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        print("in EditSceneController")
        self.title = receivedScene?.title
        viewControllerTitle = receivedScene?.title
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }

    override func viewWillAppear(_ animated: Bool) {
        print("in EditSceneController will appear")
        refreshData()
        self.title = receivedScene?.title
        theTableView?.reloadData()
    }
    
    func refreshData(){

        switches = try? context.fetch(switchReq)
        thermos = try? context.fetch(thermoReq)
        
        switchesFilter.removeAll()
        thermosFilter.removeAll()
        
        for aSwitch in switches!{
            if(aSwitch.partOfScenes?.contains(receivedScene!) == true){
                switchesFilter.append(aSwitch)
            }
        }
        
        for aThermo in thermos!{
            if(aThermo.partOfScenes?.contains(receivedScene!) == true){
                thermosFilter.append(aThermo)
            }
        }
        
        
        //To test if works
        scenSetThermosReq.predicate = NSPredicate(format: "scene == %@", (receivedScene?.objectID)!)
        scenSetSwitchesReq.predicate = NSPredicate(format: "scene == %@", (receivedScene?.objectID)!)
     
        scenSetThermos = try? context.fetch(scenSetThermosReq)
        scenSetSwitches = try? context.fetch(scenSetSwitchesReq)
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        refreshData()
        if(section == 0){
            return 1
        }
        else if(section == 1){
            var count = 0
            for aThermo in thermos!{
                let b = aThermo.partOfScenes?.contains(receivedScene!)
                if(b == true){
                    count += 1
                }
            }
            return count
        }
        else{
            var count = 0
            for aSwitch in switches!{
                let b = aSwitch.partOfScenes?.contains(receivedScene!)
                if(b == true){
                    count += 1
                }
            }
            return count
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        theTableView = tableView
        let aCell = tableView.dequeueReusableCell(withIdentifier: "switchScene", for: indexPath) as! EditSceneCellController
        refreshData()
        switch indexPath.section {
        case 0:
             let aCell = tableView.dequeueReusableCell(withIdentifier: "titleOfScene", for: indexPath) as! EditSceneCellController
            aCell.titleOfScene.text = "Title and devices of this scene"
             
            return aCell
        case 1:
            let aCell = tableView.dequeueReusableCell(withIdentifier: "termostatScene", for: indexPath) as! EditSceneCellController
            aCell.titleThermostat.text = thermosFilter[indexPath.row].title
            var targetTemp = "not yet set"
            //get target Temp of
            for aThermoTarget in scenSetThermos!{
                if(aThermoTarget.thermostat == thermosFilter[indexPath.row]){
                    targetTemp = temperatureCalculationForGUI(aThermoTarget.target_temp)
                }
            }
            
            aCell.actualTemp.text = targetTemp
            return aCell
            
        case 2:
            print("in case 2 render cells")
            let aCell = tableView.dequeueReusableCell(withIdentifier: "switchScene", for: indexPath) as! EditSceneCellController
            aCell.titleSwitch.text = switchesFilter[indexPath.row].title
            
            var swState = false
            for aSwitchTarget in scenSetSwitches!{
                if(aSwitchTarget.switchDevice == switchesFilter[indexPath.row]){
                   swState = !aSwitchTarget.state
                }
            }
            print(swState)
            
            aCell.switchButton.isOn = swState
            aCell.switchButton.isUserInteractionEnabled = false
            
            if((scenSetSwitches?.count)! == 0){
                
                let aScenSetSwitch = SceneSwitchSetting(context: context)
                aScenSetSwitch.switchDevice = switchesFilter[indexPath.row]
                aScenSetSwitch.scene = receivedScene!
                aScenSetSwitch.state = true
                do{try context.save()} catch {print(error)}
                theTableView?.reloadData()
                print("Tupel noch nicht vorhanden, erstellt")
                
            }
            
            
            return aCell
        
        default:
            print("default in override func tableView")
        }
        
        return aCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTemperature" {
            let editTemperatureViewController = segue.destination as? FaderViewController
            //daten für FaderViewController hierher
        }
        else if segue.identifier == "editDevices" {
            let EditDevicesSceneViewController = segue.destination as? NewSceneController
            if let svc = EditDevicesSceneViewController {
                svc.screenTitle = viewControllerTitle
                svc.aScene = receivedScene
            }
    }
}

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            /*let aCell = tableView.dequeueReusableCell(withIdentifier: "titleOfScene") as! EditSceneCellController
            aCell.titleOfScene.text = self.title */
        }
        else if (indexPath.section == 1){
            print("in select row setion 1")
        }
        else if (indexPath.section == 2){
            //add to scene settings if not available, alternate else
            /*let aCell = tableView.dequeueReusableCell(withIdentifier: "switchScene") as! EditSceneCellController
            
            tableView.cellForRow(at: indexPath)?.*/
            print("in select row setion 2")
            scenSetSwitchesReq.predicate = NSPredicate(format: "scene == %@ AND switchDevice == %@", (receivedScene?.objectID)!, (switchesFilter[indexPath.row].objectID))
            scenSetSwitches = try? context.fetch(scenSetSwitchesReq)
            
            print(receivedScene!.title)
            for ss in scenSetSwitches!{
                print(ss.scene?.title)
                print(ss.switchDevice?.title)
                print(ss.state)
            }

            
            if((scenSetSwitches?.count)! > 0 && (   scenSetSwitches?[0].scene == receivedScene!    )){
                print("Tupel vorhanden")
                scenSetSwitches![0].state = !scenSetSwitches![0].state
                do{try context.save()} catch {print(error)}
                theTableView?.reloadData()
            }
            
            else{
                print("komisch anzahl Items")
                print(self.scenSetSwitches?.count)
            }
            //aCell.switchButton.isOn = true
            
            
        }
    }
    
    func temperatureCalculationForGUI(_ theTemp: Float) -> String{
        var result = ""
        switch theTemp{
        case 254: result = "On"
        case 253: result = "Off"
        default: result = String(roundf(theTemp * 2)/2)
        }
        return result
    }

}
