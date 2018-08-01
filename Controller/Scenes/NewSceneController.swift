//
//  NewSceneController.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 19.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit
import CoreData

class NewSceneController: UITableViewController, UITextFieldDelegate {

    
    let context = AppDelegate.viewContext
    let switchReq: NSFetchRequest<SwitchDevice> = SwitchDevice.fetchRequest()
    let thermoReq: NSFetchRequest<Thermostat> = Thermostat.fetchRequest()
    let scenepReq: NSFetchRequest<Scene> = Scene.fetchRequest()
    
    var cellStyleForEditing: UITableViewCellEditingStyle = .none
    
    var switches: [SwitchDevice]?
    var thermos: [Thermostat]?
    var scenes: [Scene]?
    
    var screenTitle: String?
    var aScene: Scene?
    var theTableView: UITableView?
    
    override func viewDidLoad() {
        print("in NewSceneController")
        super.viewDidLoad()
        self.title = screenTitle
        
        if(aScene == nil){
            aScene = Scene(context: context)
            aScene?.title = screenTitle
            print("created a new Scene")
        }
        refreshData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("in NewSceneController will appear")
        refreshData()
        self.title = aScene?.title
        theTableView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshData(){
        switches = try? context.fetch(switchReq)
        thermos = try? context.fetch(thermoReq)
    }
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
             self.performSegue(withIdentifier: "getDevices", sender: self)
    }
    
    @IBAction func cancelCreateNewScene(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)

    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getDevices" {
            let editSceneViewController = segue.destination  as? EditSceneController
            if let svc = editSceneViewController {
                svc.data = screenTitle
                svc.receivedScene = aScene
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.theTableView = tableView
        switch section {
        case 0:
            return 1
        case 1:
            return (thermos?.count)!
        case 2:
            return (switches?.count)!
        default:
            return 0
        }

   
    }
    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath)
        -> UITableViewCellEditingStyle {
            return .none
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newPrototypeCell", for: indexPath)
        
        var cellLabel: String?
        switch indexPath.section{
            
        case 0: //Renders Title ofthe cell
            let aCell = tableView.dequeueReusableCell(withIdentifier: "titlePrototypeCell", for: indexPath) as! SceneCell
            cellLabel = screenTitle
            aCell.selectionStyle = UITableViewCellSelectionStyle.none
            aCell.titleTextField.text = self.screenTitle
            aCell.titleTextField.delegate = self
            return aCell
        
        case 1:
            cellLabel = thermos?[indexPath.row].title
            if(thermos?[indexPath.row].partOfScenes?.contains(aScene!) == true)
            {cell.accessoryType = UITableViewCellAccessoryType.checkmark}
            else{cell.accessoryType = UITableViewCellAccessoryType.none}
            
        case 2:
            cellLabel = switches?[indexPath.row].title
            if(switches?[indexPath.row].partOfScenes?.contains(aScene!) == true)
            {cell.accessoryType = UITableViewCellAccessoryType.checkmark}
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
            
            tableView.setEditing(cellStyleForEditing == .insert, animated: true)

        case 1: // adding and remocing a thermo from Scenes
            if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){
                thermos?[indexPath.row].removeFromPartOfScenes(aScene!)
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            }
            else{
                thermos?[indexPath.row].addToPartOfScenes(aScene!)
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            do{try context.save()} catch {print(error)}
            
        case 2: // Adding and removing a switch from Scnes
            if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){
                switches?[indexPath.row].removeFromPartOfScenes(aScene!)
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
                print("removed switch from Scene")
            }
            else{
                switches?[indexPath.row].addToPartOfScenes(aScene!)
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            do{try context.save()} catch {print(error)}
       
        default:
            print("default in override func tableView")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        var v : UIView = textField
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! SceneCell
        self.title = cell.titleTextField.text!
        aScene?.title = cell.titleTextField.text!
        do{try context.save()} catch {print(error)}
        
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Title"
        case 1:
            return "Thermostats"
        case 2:
            return "Switches"
        default:
            return "Some problems!"
        }
    }
}


