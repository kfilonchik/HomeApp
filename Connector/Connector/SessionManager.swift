//
//  SessionManager.swift
//  Generates a valid Session to communicate with the fritzbox
//
//  Created by Jokto on 27.05.18.
//  Copyright © 2018 MobileAnwendungen. All rights reserved.
//

import UIKit
import Foundation

class SessionManager:NSObject {
    
    var challenge:String?
    var sID:String = "0000000000000000"
    var currentParsingElement:String?
    var userName:String?
    var passWord:String?
    var fritzID:String?
    var baseURL:String?
    var delegate: LabelDelegate?
    let md5calc = Md5Maker()
    var delegateRequest:RequesterDelegate?
    
    func setDelegate(delegate: LabelDelegate) {
        self.delegate = delegate
    }
    
    func requestSID(userName: String, passWord: String, fritzID: String, baseURL: String, caller: RequesterDelegate?){
        self.userName = userName
        self.passWord = passWord
        self.fritzID = fritzID
        self.baseURL = baseURL
        delegateRequest = caller
        getSessionID()
    }

    func getSessionID(){
        var sessionUrl = URL(string: baseURL!+"getChallenge.php?fritz_id="+fritzID!)
        if (challenge != nil && passWord != nil && fritzID != nil && userName != nil) {
            
            let checksum = md5calc.MD5(challenge: challenge!, password: passWord!)
            //let URLstring = baseURL + "getSessionID.php?fritz_id="+fritzID!+"&user="+userName!+"&md5calc="+checksum!
            let urlString = ("\(baseURL!)getSessionID.php?fritz_id=\(fritzID!)&user=\(userName!)&md5calc=\(checksum)")
            sessionUrl = URL(string: urlString)
        }
    
        let task = URLSession.shared.dataTask(with: sessionUrl!) { (data, response, error) in
            
            if data == nil {
                print("dataTaskWithRequest error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            let parser = XMLParser(data: data!)
            self.delegate?.addLongTex(value: String(data: data!, encoding: .utf8)!)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
}

//-------------------------------------------------
extension SessionManager:XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentParsingElement = elementName
        if elementName == "SessionInfo" {
            //print("Started parsing...")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            if currentParsingElement == "Challenge" {
                challenge = foundedChar
            }
            else if currentParsingElement == "SID"{
                sID = foundedChar
                }
            }
        }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "SessionInfo" {
            //print("Ended parsing...")
            self.delegate?.addTextToLabel(value: self.sID)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            if self.sID == "0000000000000000" {
                self.getSessionID()
            }
            else if self.sID != "0000000000000000"{
                self.delegateRequest?.transferSID(self.sID)
                }
            }
        }
    
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
}
