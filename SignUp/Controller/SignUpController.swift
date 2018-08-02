//
//  SignUpControllerViewController.swift
//  test
//
//  Created by Khristina Filonchik on 15.06.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit
import CoreData

class SignUpController: UIViewController {
    
    let context = AppDelegate.viewContext
    
    @IBOutlet weak var textFritzID: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textUserName: UITextField!
    
    @IBAction func Sign(_ sender: UIButton) {

        let userFritzID = textFritzID.text
        let userName = textUserName.text
        let userPassword = textPassword.text

        if (userFritzID!.isEmpty || userPassword!.isEmpty || userName!.isEmpty) {
            print("in empty if")
            displayAllertMessage(userMessage: "All fields required")
            return;
        }
        else if (!userFritzID!.isEmpty && !userPassword!.isEmpty && !userName!.isEmpty){
            print("startetd storing settings")
            let stdAppSettings = AppSettings(context: context)
            stdAppSettings.userName = textUserName.text
            stdAppSettings.fritzID = textFritzID.text
            stdAppSettings.passWord = textPassword.text
        
            do{ // persist data
                try context.save()
            } catch {
                print(error)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
    func displayAllertMessage(userMessage: String) {
        let allert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert);
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
        
        allert.addAction(okAction);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
}
