//
//  ViewController.swift
//  httpRequest
//
//  Created by Jokto on 26.05.18.
//  Copyright © 2018 MobileAnwendungen. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
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
    
    
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var resultText: UITextField!
    @IBOutlet weak var sollTempEingabe: UITextField!
    @IBOutlet weak var sollTempDisplay: UITextField!
    @IBOutlet weak var switchStateFromFritz: UITextField!
    
    
    @IBAction func okButton(_ sender: UIButton) {
        aConnector.setPW(pwField.text!)
    }
    
    @IBAction func doStuff(_ sender: UIButton) {
        thermosID = idIndexer.index(of: "11960 0086040")
        switchID = idIndexer.index(of: "08761 0437714")
        aConnector.getAllDevices()

        
    }
    
    @IBAction func doCoreData(_ sender: UIButton) {
        let request: NSFetchRequest<Thermostat> = Thermostat.fetchRequest()
        let result = try? context.fetch(request)
        for aresult in result!{
            print(aresult.target_temp)
        }
    }
    
    
    @IBAction func sendTempOKbtn(_ sender: UIButton) {
        aConnector.setTemperature(deviceID: "11960 0086040", temperature: sollTempEingabe.text!)
    }
    
    @IBAction func aSwitch(_ sender: UISwitch) {
        aConnector.setSwitchState(deviceID: "08761 0437714", state: sender.isOn)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let stdAppSettings = AppSettings(context: context)
        stdAppSettings.userName = "domovoi"
        stdAppSettings.fritzID = "7ncvvd2irftxy2fv"
        aConnector.startUpConnector(self)
    }
    func updateUI(){
        if thermosID != nil{
            print("update UI ausgelöst")
            sollTempDisplay.text = deviceList?[thermosID!]["tsoll"]
            resultText.text = deviceList?[thermosID!]["name"]
            switchStateFromFritz.text = deviceList?[switchID!]["state"]
        }

    }
    
}


//-------------------------------------------
extension ViewController: LabelDelegate{
    func currentDeviceStateList(_ deviceList:[[String : String]]) {
        print("currentDeviceStateList im ViewController ausgelöst")
        self.deviceList = deviceList
        self.updateUI()
    }
    
    
    func addTemp(value: String) {
        
    }
    
    func addLongTex(value: String) {
        
    }
    
    func addTextToLabel(value: String) {
        
    }
}
