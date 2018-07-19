//
//  SceneTableViewController.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 19.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit
import CoreData

class SceneTableViewController: UITableViewController {
    
     let context = AppDelegate.viewContext

    @IBAction func newScene(_ sender: UIButton) {
        
        print("Hello")
    }
    
    
    @IBAction func deleteScene(_ sender: UIButton) {
         self.performSegue(withIdentifier: "deleteScene", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         tableView.register(UINib(nibName: "SceneCell", bundle: nil), forCellReuseIdentifier: "SceneCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sceneRequest: NSFetchRequest<SceneTile> = SceneTile.fetchRequest()
        let scenes = try? context.fetch(sceneRequest)
       
    
        if section == 0 {
            return scenes!.count
            
        }
     
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sceneRequest: NSFetchRequest<SceneTile> = SceneTile.fetchRequest()
        let scenes = try? context.fetch(sceneRequest)
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SceneCell") as! SceneCell
            cell.SceneCellTitle.text = scenes?[indexPath.item].title
            
            //  cell.GroupTitleThermostat.text = "test"
            return cell
        }

        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }


    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath:IndexPath) -> Int {
        if indexPath.section == 0 {
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }
        
        return super.tableView(tableView, indentationLevelForRowAt: indexPath as IndexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0  {
            return 44
        }
      
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    

}
