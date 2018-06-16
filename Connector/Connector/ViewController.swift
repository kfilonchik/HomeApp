//
//  ViewController.swift
//  httpRequest
//
//  Created by Jokto on 26.05.18.
//  Copyright © 2018 MobileAnwendungen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let aFritzConnector = Connector()
    
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
    
    
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var resultText: UITextField!
    @IBOutlet weak var sollTempEingabe: UITextField!
    @IBOutlet weak var sollTempDisplay: UITextField!
    @IBOutlet weak var switchStateFromFritz: UITextField!
    
    
    @IBAction func okButton(_ sender: UIButton) {
        aFritzConnector.setPW(pwField.text!)
    }
    
    @IBAction func doStuff(_ sender: UIButton) {
        thermosID = idIndexer.index(of: "11960 0086040")
        switchID = idIndexer.index(of: "08761 0437714")
        aFritzConnector.getAllDevices()
    }
    
    @IBAction func sendTempOKbtn(_ sender: UIButton) {
        aFritzConnector.setTemperature(deviceID: "11960 0086040", temperature: sollTempEingabe.text!)
    }
    
    @IBAction func aSwitch(_ sender: UISwitch) {
        aFritzConnector.setSwitchState(deviceID: "08761 0437714", state: sender.isOn)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aFritzConnector.startUpConnector(self)
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
