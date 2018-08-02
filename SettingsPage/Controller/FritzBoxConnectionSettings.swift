//
//  FritzBoxConnectionSettings.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 28.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit
import CoreData

class FritzBoxConnectionSettings: UITableViewController, UITextFieldDelegate {
     let context = AppDelegate.viewContext
    
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        print("delete procedure")
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(batchDeleteRequest)
            
        } catch {
            // Error Handling
        }
        context.reset()
        
        
        textFieldFritzId.text = ""
        textFieldUser.text = ""
        textFieldPassword.text = ""
    }
    @IBAction func saveBtn(_ sender: UIButton) {
        
        let stdAppSettings = AppSettings(context: context)
       
        stdAppSettings.fritzID = textFieldFritzId.text
        stdAppSettings.passWord = textFieldPassword.text
        stdAppSettings.userName = textFieldUser.text
        
        
        do{ // persist data
            try context.save()
            
        } catch {
            print("mistake", error)
        }
        
        
    }
    
    @IBOutlet weak var textFieldUser: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldFritzId: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getAppSettings()
       
        textFieldFritzId.delegate = self
        textFieldUser.delegate = self
        textFieldPassword.delegate = self
        
       
        self.tableView.reloadData()
        
    }
    
    private func getAppSettings() {
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
       
        let settingsFritz = try? context.fetch(fetchRequest)
         print(settingsFritz![0].fritzID)
       textFieldFritzId.text = settingsFritz![0].fritzID
    
        textFieldUser.text = settingsFritz![0].userName
        textFieldPassword.text = settingsFritz![0].passWord
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
