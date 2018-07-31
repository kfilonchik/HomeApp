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
    let sceneReq: NSFetchRequest<Scene> = Scene.fetchRequest()
    
    var switches: [SwitchDevice]?
    var thermos: [Thermostat]?
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    // MARK: - Table view data source

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
                if(aThermo.partOfScenes?.contains(receivedScene!))!{
                    count += 1
                }
            }
            return count
        }
        else{
            var count = 0
            for aSwitch in switches!{
                if(aSwitch.partOfScenes?.contains(receivedScene!))!{
                    count += 1
                }
            }
            return count
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        theTableView = tableView
        let aCell = tableView.dequeueReusableCell(withIdentifier: "switchScene", for: indexPath) as! EditSceneCellController
        switch indexPath.section {
        case 0:
             let aCell = tableView.dequeueReusableCell(withIdentifier: "titleOfScene", for: indexPath) as! EditSceneCellController
            aCell.titleOfScene.text = "Title and devices of this scene"
             
            return aCell
        case 1:
            let aCell = tableView.dequeueReusableCell(withIdentifier: "termostatScene", for: indexPath) as! EditSceneCellController
            aCell.titleThermostat.text = "Thermostat1"
            aCell.actualTemp.text = "23,5"
            return aCell
            
        case 2:
            let aCell = tableView.dequeueReusableCell(withIdentifier: "switchScene", for: indexPath) as! EditSceneCellController
            aCell.titleSwitch.text = "Switch1"
            aCell.switchButton.isOn = true
        
        default:
            print("default in override func tableView")
        }
        
        return aCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTemperature" {
            let editTemperatureViewController = segue.destination as? FaderViewController
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
            let aCell = tableView.dequeueReusableCell(withIdentifier: "titleOfScene") as! EditSceneCellController
            aCell.titleOfScene.text = self.title
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
