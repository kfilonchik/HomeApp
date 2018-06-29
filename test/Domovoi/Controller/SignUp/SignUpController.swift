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
    
    let aConnector = Connector()
    
    let container = AppDelegate.persistentContainer
    let context = AppDelegate.viewContext
    
    
    @IBOutlet weak var textFritzID: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textUserName: UITextField!
    
    
    
    @IBAction func Sign(_ sender: UIButton) {
       print("login gedrückt")
        
       
    /*
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardView")
        
        self.present(viewController, animated: false, completion: nil)
 */
    
    // check for empty fields
        
        var userFritzID = textFritzID.text
        let userName = textUserName.text
        let userPassword = textPassword.text
        let stdAppSettings = AppSettings(context: context)
        stdAppSettings.userName = textUserName.text
        stdAppSettings.fritzID = textFritzID.text
        
        if (userFritzID! == "" || userPassword!.isEmpty || userName!.isEmpty) {
            print("in empty if")
            displayAllertMessage(userMessage: "All fields required")
            return;
        }
        
        
        UserDefaults.standard.set(false, forKey: "isLogged");
        UserDefaults.standard.synchronize()
        self.dismiss(animated: true, completion: nil)
    }
    func displayAllertMessage(userMessage: String) {
        let allert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert);
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
        
        allert.addAction(okAction);
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()



        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "mainPage", sender: self)
        
    }
  */
    
  
}
