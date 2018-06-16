//
//  Connector.swift
//  httpRequest
//
//  Created by Jokto on 01.06.18.
//  Copyright © 2018 MobileAnwendungen. All rights reserved.
//

import UIKit
import Foundation

class Connector:NSObject {
    let userName:String = "domovoi"
    var passWord:String?{
        didSet{
            getSessionID()
            startMainOperatorThermostat()
            startAllDeviceReceiver()
        }
    }
    let fritzID:String = "7ncvvd2irftxy2fv"
    let baseURL:String = "https://clapotis.de/MobileAnwendungenSS18/"
    let aSessionManager = SessionManager()
    let anOperation = Operation()
    let anAllDeviceReceiver = AllDevicesReceiver()
    var sessionID:String?
    var retryCounter = 0
    var deviceList: [[String : String]]?
    var uiDelegate: LabelDelegate?
    
    
    func startUpConnector(_ viewC: LabelDelegate){
        self.uiDelegate = viewC
        if passWord != nil{
            getSessionID()
            startMainOperatorThermostat()
            startAllDeviceReceiver()
        }

    }
    
    func getSessionID(){
        aSessionManager.requestSID(userName: userName, passWord: passWord!, fritzID: fritzID, baseURL: baseURL, caller: self)

    }
    func startMainOperatorThermostat(){
        anOperation.setOperationReady(userName: userName, passWord: passWord!, fritzID: fritzID, baseURL: baseURL, delegate: self)
    }
    
    func startAllDeviceReceiver(){
        anAllDeviceReceiver.startOperator(userName: userName, passWord: passWord!, fritzID: fritzID, baseURL: baseURL, delegate: self)
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
    
    func getTemperature(_ deviceID: String) -> Float{
        return 25.3
    }
    func getSwitchState(_ deviceID: String)->Int{
        return 1
    }
    func setSwitchState(deviceID: String, state: Bool){
        var stateStr = ""
        if state == true{stateStr = "setswitchon"}
        else {stateStr = "setswitchoff" }
        anOperation.performOperation(ain: deviceID, cmd: stateStr, sID: sessionID!, parameter:"")
        
    }
    func getThermosetateList()->[[String : String]]{
        return [["": ""]]
    }
    func getSwitchList()->[[String : String]]{
        return [["": ""]]
    }
    
    func setPW(_ pw: String){
        self.passWord = pw
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
    }
    
    
    func refreshSID() {
        getSessionID()
    }
    
    func transferSID(_ sessionID: String) {
        print("SessionID erhalten: \(sessionID)")
        self.sessionID = sessionID
        self.getAllDevices()
    }
}
