//
//  SignUpControllerViewController.swift
//  test
//
//  Created by Khristina Filonchik on 15.06.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
    
    let aConnector = Connector()
    
    var thermosID:Int?
    var switchID:Int?
    var disText:String?
    var idIndexer = [String]()
    var deviceList: [[String : String]]?{
        didSet{
            idIndexer.removeAll()
            for aDev in deviceList!{
                idIndexer.append(aDev["id"]!)
            }
        }
    }
    let container = AppDelegate.persistentContainer
    let context = AppDelegate.viewContext
    
    
    @IBOutlet weak var textFritzID: UITextField!
    
    @IBOutlet weak var textPassword: UITextField!
 
    @IBOutlet weak var textUserName: UITextField!
    
    
    
    @IBAction func Sign(_ sender: UIButton) {
        
       
        
       
    /*
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardView")
        
        self.present(viewController, animated: false, completion: nil)
 */
    
    // check for empty fields
        /*
        var userFritzID = textFritzID.text
        let userName = textUserName.text
        let userPassword = textPassword.text
        
        if (userFritzID!.isEmpty || userPassword!.isEmpty || userName!.isEmpty) {
            displayAllertMessage(userMessage: "All fields required")
            return;
        }
         */
        
        
        let stdAppsettings = AppSettings(context: context)
        
       // stdAppsettings.userName = textUserName.text
       // stdAppsettings.fritzID = textFritzID.text
        stdAppsettings.passWord = textPassword.text
        
        
       aConnector.setPW(textPassword.text!)
       // aConnector.setUserName(userName!)
        //aConnector.setFritzID(fritzID!)
         aConnector.startUpConnector(self)
        UserDefaults.standard.set(true, forKey: "isLogged");
        UserDefaults.standard.synchronize()
       // let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardView")
        
        //self.present(viewController, animated: false, completion: nil)
        self.dismiss(animated: true, completion: nil)
  
        
    }
    func displayAllertMessage(userMessage: String) {
        let allert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert);
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
        
        allert.addAction(okAction);
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
       /* let stdAppSettings = AppSettings(context: context)
        stdAppSettings.userName = textUserName.text
        stdAppSettings.fritzID = textFritzID.text */

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateUI(){
        if thermosID != nil{
            print("update UI ausgelöst")
            
        }
    

/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "mainPage", sender: self)
        
    }
  */
    

    }
    
}

//-------------------------------------------
extension SignUpController: LabelDelegate{
    func currentDeviceStateList(_ deviceList:[[String : String]]) {
        print("currentDeviceStateList im ViewController ausgelöst")
        self.deviceList = deviceList
        print(deviceList)
        self.updateUI()
    }
    
    
    func addTemp(value: String) {
        
    }
    
    func addLongTex(value: String) {
        
    }
    
    func addTextToLabel(value: String) {
        
    }
}

