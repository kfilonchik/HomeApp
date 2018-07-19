//
//  DeleteCellController.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 19.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit
import CoreData

class DeleteCellController: UITableViewController {
    
    let context = AppDelegate.viewContext

    @IBAction func DeleteScene(_ sender: UIButton) {
        print("delete procedure scenes")
        let SceneRequest: NSFetchRequest<Scene> = Scene.fetchRequest()
        
        // Create Batch Delete Request
        let sceneDeleteRequest = NSBatchDeleteRequest(fetchRequest: SceneRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(sceneDeleteRequest)
            
        } catch {
            // Error Handling
        }
        context.reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sceneRequest: NSFetchRequest<Scene> = Scene.fetchRequest()
        let scenes = try? context.fetch(sceneRequest)
        return scenes!.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sceneRequest: NSFetchRequest<Scene> = Scene.fetchRequest()
        let scenes = try? context.fetch(sceneRequest)
        
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "sceneDeleteCell", for: indexPath) as! DeleteSceneCell

        aCell.TitleDeleteSceneCell.text = scenes?[indexPath.item].title
        return aCell
    }

}
