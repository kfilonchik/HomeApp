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
    let mainSessionManager = FritzSessionManager()
    let mainOperatorThermostat = OperationThermostat()
    let allDeviceReceiver = AllThermostatsReceiver()
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
        mainSessionManager.requestSID(userName: userName, passWord: passWord!, fritzID: fritzID, baseURL: baseURL, caller: self)

    }
    func startMainOperatorThermostat(){
        mainOperatorThermostat.startOperator(userName: userName, passWord: passWord!, fritzID: fritzID, baseURL: baseURL, delegate: self)
    }
    
    func startAllDeviceReceiver(){
        allDeviceReceiver.startOperator(userName: userName, passWord: passWord!, fritzID: fritzID, baseURL: baseURL, delegate: self)
    }
    
    func getAllDevices(){
        if sessionID != nil{
            print("getAllDevices ausgelöst")
            allDeviceReceiver.getThermostatList(cmd: "getdevicelistinfos", sID: sessionID!)
        }
    }
    
    func setTemperature(deviceID: String, temperature: String){
        mainOperatorThermostat.performOperation(ain: deviceID, cmd: "sethkrtsoll", sID: sessionID!, parameter: temperature)
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
        mainOperatorThermostat.performOperation(ain: deviceID, cmd: stateStr, sID: sessionID!, parameter:"")
        
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
