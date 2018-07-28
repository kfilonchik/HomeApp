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
    

    @IBAction func newScene(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Give a title for your scene", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your name here..."})
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                print("Title: \(name)")
                self.titel = name
            }
            self.performSegue(withIdentifier: "newScene", sender: self)
        }))
        self.present(alert, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newScene" {
            let newSceneViewController = segue.destination as? NewSceneController
            if let svc = newSceneViewController {
                svc.data = titel
    }
        } else if segue.identifier == "editCell" {
            let newSceneViewController = segue.destination as? NewSceneController
            if let svc = newSceneViewController {
                svc.data = titel
        }
        }
}
    func refreshData(){
        scenes = try? context.fetch(sceneRequest)
        
    }
    //Delete Scene
    /*
    func confirmDelete(scene: String) {
        let alert = UIAlertController(title: "Delete Scene", message: "Are you sure you want to permanently delete \(scene)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteScene)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteScene)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        //alert.popoverPresentationController?.sourceView = self.view
        //alert.popoverPresentationController?.sourceRect = CGRect(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteScene (alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteSceneIndexPath {
            tableView.beginUpdates()
            
            scenes!.remove(at: indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            
            deleteSceneIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteScene(alertAction: UIAlertAction!) {
        deleteSceneIndexPath = nil
    }

 
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath) {
       
        if editingStyle == .delete {
            deleteSceneIndexPath = indexPath
            let sceneToDelete = scenes![indexPath.row].title
            confirmDelete(scene: sceneToDelete!)
        }
    }
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
         tableView.register(UINib(nibName: "SceneCell", bundle: nil), forCellReuseIdentifier: "SceneCell")
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (scenes?.count)!
            
        }
     
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // let sceneRequest: NSFetchRequest<Scene> = Scene.fetchRequest()
      //  let scenes = try? context.fetch(sceneRequest)
        
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
            self.performSegue(withIdentifier: "editCell", sender: self)
         
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0  {
            return 44
        }
      
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    //delete button, it works but we need to delete scene by the right way...
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.scenes!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

