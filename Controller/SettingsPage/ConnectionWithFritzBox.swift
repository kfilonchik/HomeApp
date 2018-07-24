//
//  ConnectionWithFritzBox.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 25.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ConnectionWithFritzBox: UIViewController {
let context = AppDelegate.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        
        User.text = result![0].userName
       FritzID.text = result![0].fritzID
      Password.text = result![0].passWord
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveNewConnection(_ sender: RoundButton) {
        let stdAppSettings = AppSettings(context: context)
        stdAppSettings.userName = User.text
        stdAppSettings.fritzID = FritzID.text
        stdAppSettings.passWord = Password.text
        
        do{ // persist data
            try context.save()
            
        } catch {
            print(error)
        }

    }
    @IBAction func deleteConnection(_ sender: RoundButton) {
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
        
        FritzID.text = ""
         User.text = ""
         Password.text = ""
    }
    
    @IBOutlet weak var FritzID: UITextField!
    
    @IBOutlet weak var User: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
}
