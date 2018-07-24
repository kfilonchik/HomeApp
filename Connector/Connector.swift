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
    let aModelExecutor = ModelExecutor()
    var sessionID:String?
    var sIDdefault:String = "0000000000000000"
    var deviceList: [[String : String]]?
    var uiDelegate: LabelDelegate?
    var retry_counter = 0
    
    func startUpConnector(){
        let context = AppDelegate.viewContext
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        if (result?.count == 1){
            passWord = result![0].passWord
            userName = result![0].userName
            fritzID  = result![0].fritzID
            
            getSessionID()
            aModelExecutor.startUp(self)
            starOperatorObject()
            startAllDeviceReceiver()
        }
        else{
            print("fehler beim Starten des Connectors, Username Passwort korrekt?")
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
        if (sessionID != nil && sessionID != sIDdefault){
            print("getAllDevices ausgelöst")
            anAllDeviceReceiver.getAllDevices(cmd: "getdevicelistinfos", sID: sessionID!)
        }
        else{
            print("no getAllDevices() because of missing Session ID. Will retry to get session id.")
            startUpConnector()
        }
    }
    
    func setTemperature(deviceID: String, temperature: String){
        if (sessionID != nil && sessionID != sIDdefault){
            anOperation.performOperation(ain: deviceID, cmd: "sethkrtsoll", sID: sessionID!, parameter: temperature)
        }
        else{
            print("no setTemperature() because of missing Session ID. Will retry to get session id.")
            startUpConnector()
        }
    }
    
    func setSwitchState(deviceID: String, state: Bool){
        if (sessionID != nil && sessionID != sIDdefault){
            var stateStr = ""
            if state == true{stateStr = "setswitchon"}
            else {stateStr = "setswitchoff" }
            anOperation.performOperation(ain: deviceID, cmd: stateStr, sID: sessionID!, parameter:"")
        }
        else{
            print("no setSwitchState() because of missing Session ID. Will retry to get session id.")
            startUpConnector()
        }
    }
}


//-------------------------------------------------
extension Connector:RequesterDelegate{
    func taskFromModelExecutorSwitch(id: String, state: Bool) {
        self.setSwitchState(deviceID: id, state: state)
    }
    
    func taskFromModelExecutorThermostat(id: String, temperature: Float) {
        if (temperature >= 8 && temperature <= 28){
            let temperatureCalculation = String(round(temperature * 2))
            self.setTemperature(deviceID: id, temperature: temperatureCalculation)
        }
        else if(temperature == 254 || temperature == 253){
            self.setTemperature(deviceID: id, temperature: String(temperature))
        }
    }
    
    func replyMainOperatorThermostat(_ reply: String) {
        print("Conncetor.swift: Antwort des Setzvorgangs \(reply)")
        self.getAllDevices()
    }
    
    func transferSID(_ sessionID: String) {
        print("SessionID erhalten: \(sessionID)")
        self.sessionID = sessionID
        self.getAllDevices()
    }
    func connectionError(_ message: String){
        print(message)
        self.sessionID = sIDdefault
        if(retry_counter < 6){
            print("retrying to get sessionID")
            getSessionID()
            retry_counter += 1
            
            if (retry_counter == 6){
                print("stopped trying to connect there seems to be an error. Restart Fritz Box and App")
            }
        }
    }
}
