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
    var titel: String?
    var deleteSceneIndexPath: IndexPath? = nil
    let context = AppDelegate.viewContext
    let sceneRequest: NSFetchRequest<Scene> = Scene.fetchRequest()
    var scenes: [Scene]?
    var aSceneForTransfer: Scene?
    var theTableView: UITableView?
    let cellHeight:CGFloat = 44
    
    
    override func viewDidLoad() {
        print("in SceneTableViewController")
        super.viewDidLoad()
        refreshData()
        
        tableView.register(UINib(nibName: "SceneCell", bundle: nil), forCellReuseIdentifier: "SceneCell")
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("in SceneTableViewController will appear")
        refreshData()
        self.title = aSceneForTransfer?.title
        theTableView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshData(){
        scenes = try? context.fetch(sceneRequest)
    }
    
//aler make new scene
    @IBAction func newScene(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Name of the scene:", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "enter your title here..."})
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                print("Title: \(name)")
                self.titel = name
            }
            self.performSegue(withIdentifier: "newScene", sender: self)
        }))
        self.present(alert, animated: true)
    }
    
  //segue to give title to next controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newScene" {
        if let navController = segue.destination as? UINavigationController {
            let newSceneViewController = navController.topViewController as? NewSceneController
            if let svc = newSceneViewController {
                svc.screenTitle = titel
                }
            }
        } else if segue.identifier == "editCell" {
            if let navController = segue.destination as? UINavigationController {
                let editSceneViewController = navController.topViewController as? EditSceneController
                if let svc = editSceneViewController {
                    svc.data = titel
                    svc.receivedScene = aSceneForTransfer
                }
            }
    }
}


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            theTableView = tableView
            refreshData()
            return (scenes?.count)!
            
        }
     
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        theTableView = tableView
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SceneCell") as! SceneCell
            cell.SceneCellTitle.text = scenes?[indexPath.row].title
            
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
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SceneCell") as! SceneCell
            cell.SceneCellTitle.text = scenes?[indexPath.row].title
            self.titel = scenes?[indexPath.row].title
            aSceneForTransfer = scenes?[indexPath.row]
            self.performSegue(withIdentifier: "editCell", sender: self)
         
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0  {
            return cellHeight
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    //delete button, it works but we need to delete scene by the right way...
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            context.delete(scenes![indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            do{try context.save()} catch {print(error)}
            
        }
    }

}


