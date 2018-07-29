//
//  EditSceneController.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 29.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit

class EditSceneController: UITableViewController {
    
    var data: String?
    var titel: String?

    
    @IBAction func goToMainPage(_ sender: UIBarButtonItem) {
         self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let concreteData = data {
            titel = concreteData
        }
        
        self.navigationItem.hidesBackButton = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let aCell = tableView.dequeueReusableCell(withIdentifier: "switchScene", for: indexPath) as! EditSceneCellController
        switch indexPath.section {
        case 0:
             let aCell = tableView.dequeueReusableCell(withIdentifier: "titleOfScene", for: indexPath) as! EditSceneCellController
             
            aCell.titleOfScene.text = self.titel
             
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
        aCell.titleSwitch.text = "Switch1"
        aCell.switchButton.isOn = true
        return aCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTemperature" {
            let editTemperatureViewController = segue.destination  as? FaderViewController
        } else if segue.identifier == "editDevices" {
            if let navController = segue.destination as? UINavigationController {
                let NewSceneViewController = navController.topViewController as? NewSceneController
            if let svc = NewSceneViewController {
                svc.data = titel
            }
        }
    }
}

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let aCell = tableView.dequeueReusableCell(withIdentifier: "titleOfScene") as! EditSceneCellController
            aCell.titleOfScene.text = self.title
        
            self.performSegue(withIdentifier: "editDevices", sender: self)
            
        }
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
