//
//  SettingsTableViewTableViewController.swift
//  test
//
//  Created by Khristina Filonchik on 31.05.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit
import CoreData


class SettingsTableViewController: UITableViewController {
   
    var cellName = ["test"]

  
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"settingsCell", for: indexPath)
        
     let name = cellName[indexPath.row]
      cell.textLabel?.text = name
       // cell.textFieldFritzId.text = result![0].fritzID
        return cell

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "connectionWithFritzBox"{
            let vc = segue.destination as! ConnectionWithFritzBox
            
        }
        
    }

}
