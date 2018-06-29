//
//  Connector.swift
//  httpRequest
//
//  Created by Jokto on 01.06.18.
//  Copyright © 2018 MobileAnwendungen. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class Connector:NSObject {
    var userName:String? // = "domovoi"
    var passWord:String?
    var fritzID:String? // = "7ncvvd2irftxy2fv"
    let baseURL:String = "https://clapotis.de/MobileAnwendungenSS18/"
    let aSessionManager = SessionManager()
    let anOperation = Operation()
    let anAllDeviceReceiver = AllDevicesReceiver()
    var sessionID:String?
    var deviceList: [[String : String]]?
    var uiDelegate: LabelDelegate?
    
    func startUpConnector(){
        let context = AppDelegate.viewContext
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        if (result?.count == 1){
            passWord = result![0].passWord
            userName = result![0].userName
            fritzID  = result![0].fritzID
            
            getSessionID()
            starOperatorObject()
            startAllDeviceReceiver()
        }
        else{
            print("fehler beim starten des Connectors")
        }
    }
    
    func getSessionID(){
        aSessionManager.requestSID(userName: userName!, passWord: passWord!, fritzID: fritzID!, baseURL: baseURL, caller: self)
        
    }
    func starOperatorObject(){
        anOperation.setOperationReady(userName: userName!, passWord: passWord!, fritzID: fritzID!, baseURL: baseURL, delegate: self)
    }
    
    func startAllDeviceReceiver(){
        anAllDeviceReceiver.startOperator(userName: userName!, passWord: passWord!, fritzID: fritzID!, baseURL: baseURL, delegate: self)
    }
    
    func getAllDevices(){
        if sessionID != nil{
            print("getAllDevices ausgelöst")
            anAllDeviceReceiver.getAllDevices(cmd: "getdevicelistinfos", sID: sessionID!)
        }
    }
    
    func setTemperature(deviceID: String, temperature: String){
        anOperation.performOperation(ain: deviceID, cmd: "sethkrtsoll", sID: sessionID!, parameter: temperature)
    }
    
    func setSwitchState(deviceID: String, state: Bool){
        var stateStr = ""
        if state == true{stateStr = "setswitchon"}
        else {stateStr = "setswitchoff" }
        anOperation.performOperation(ain: deviceID, cmd: stateStr, sID: sessionID!, parameter:"")
        
    }
}


//-------------------------------------------------
extension Connector:RequesterDelegate{
    func replyMainOperatorThermostat(_ reply: String) {
        print("Antwort des Setzvorgangs \(reply)")
        self.getAllDevices()
    }
    
    func replyDeviceList(_ deviceList: [[String : String]]) {
        self.deviceList = deviceList
        uiDelegate?.currentDeviceStateList(deviceList)
        print(deviceList)
    }
    
    func transferSID(_ sessionID: String) {
        print("SessionID erhalten: \(sessionID)")
        self.sessionID = sessionID
        self.getAllDevices()
    }
}
