//
//  ConnectionFritzViewController.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 08.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit
import CoreData

class ConnectionFritzViewController: UIViewController {
    
     let context = AppDelegate.viewContext
     let aConnector = Connector()
    
    @IBOutlet weak var textFieldId: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPass: UITextField!
    
    @IBAction func DeleteBtn(_ sender: UIButton) {
        let bla = ManageDB()
        bla.deleteAppSettings()

    }
    
    @IBAction func EditBtn(_ sender: UIButton) {
        password.isHidden = true
        userName.isHidden = true
        fritzID.isHidden = true
        textFieldPass.isHidden = false
        textFieldId.isHidden = false
        textFieldName.isHidden = false
        
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        let stdAppSettings = AppSettings(context: context)
        stdAppSettings.fritzID = textFieldId.text
        stdAppSettings.userName = textFieldName.text
        stdAppSettings.passWord = textFieldPass.text
        
        textFieldPass.isHidden = true
        textFieldId.isHidden = true
        textFieldName.isHidden = true
        
        password.isHidden = false
        userName.isHidden = false
        fritzID.isHidden = false
        
        fritzID.text = textFieldId.text
        userName.text = textFieldName.text
        password.text = textFieldPass.text
        
    
        do{ // persist data
            try context.save()
            
        } catch {
            print(error)
        }
        
    }
    
    @IBOutlet weak var fritzID: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var password: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        
        fritzID.text = result![0].fritzID
        userName.text = result![0].userName
        password.text = result![0].passWord
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
