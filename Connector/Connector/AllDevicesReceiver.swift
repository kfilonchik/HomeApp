//
//  SessionManager.swift
//  httpRequest
//
//  Created by Jokto on 27.05.18.
//  Copyright © 2018 MobileAnwendungen. All rights reserved.
//

import UIKit
import CoreData

class AllDevicesReceiver: NSObject {
    
    var currentParsingElement:String?
    var userName:String?
    var passWord:String?
    var fritzID:String?
    var baseURL:String?
    var delegate: RequesterDelegate?
    var paramterAnswer: String?
    var devicesArray = [[String: String]]()
    var attributeDict = [String: String]()
    
    let container = AppDelegate.persistentContainer
    let context = AppDelegate.viewContext
    
    func startOperator(userName: String, passWord: String, fritzID: String, baseURL: String, delegate: RequesterDelegate){
        self.userName = userName
        self.passWord = passWord
        self.fritzID = fritzID
        self.baseURL = baseURL
        self.delegate = delegate
    }
    
    func cleanAin(_ toConvert:String) -> String{
        let csCopy = CharacterSet(bitmapRepresentation: CharacterSet.urlPathAllowed.bitmapRepresentation)
        return toConvert.addingPercentEncoding(withAllowedCharacters: csCopy)!
    }
    
    func getAllDevices(cmd: String, sID: String){
        devicesArray.removeAll()
        let urlString = "\(baseURL!)deviceList.php?fritz_id=\(fritzID!)&cmd=\(cmd)&sid=\(sID)"
        let perfUrl = URL(string: urlString)
        let taskOperation = URLSession.shared.dataTask(with: perfUrl!) { (data, response, error) in
            
            if (data == nil)  {
                print("dataTaskWithRequest error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            let parser = XMLParser(data: data!)
            parser.delegate = self
            parser.parse()
        }
        
        taskOperation.resume()
    }
}
extension AllDevicesReceiver:XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentParsingElement = elementName
        
        if elementName == "devicelist" {
            //print("Started parsing...")
        }
        else if elementName == "device"{
            self.attributeDict["id"] = attributeDict["identifier"]
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            self.attributeDict[currentParsingElement!] = foundedChar
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "device" {
            devicesArray.append(attributeDict)
            attributeDict.removeAll(keepingCapacity: false)
            
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.delegate?.replyDeviceList(self.devicesArray)
            self.writeToCoreData(self.devicesArray)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
    
    func writeToCoreData(_ devicesArray: [[String: String]]){
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        for device in devicesArray{
            if device["state"] == nil{
                let thermostat = Thermostat(context: context)
                thermostat.id = device["id"]
                thermostat.title = device["name"]
                thermostat.actual_temp = Float(device["tist"]!)!/2
                thermostat.alive = true
                let tsoll = Float(device["tsoll"]!)
                if tsoll! < 57.0{
                    thermostat.target_temp = tsoll!/2
                }
                else{
                    thermostat.target_temp = tsoll!
                }
                do{
                    try context.save()
                } catch {
                    print(error)
                }
                
            }
            if device["state"] != nil{
                //write all switch stuff to db
                print("schalter")
            }
        }
        
    }
    
}
