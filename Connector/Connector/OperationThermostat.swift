//
//  SessionManager.swift
//  httpRequest
//
//  Created by Jokto on 27.05.18.
//  Copyright © 2018 MobileAnwendungen. All rights reserved.
//

import UIKit

class OperationThermostat: NSObject {

    var currentParsingElement:String?
    var userName:String?
    var passWord:String?
    var fritzID:String?
    var baseURL:String?
    var delegate: RequesterDelegate?
    var paramterAnswer: String?
    
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
    
    func performOperation(ain: String, cmd: String, sID: String, parameter: String){
        let urlString = "\(baseURL!)operationsParam.php?fritz_id=\(fritzID!)&ain=\(cleanAin(ain))&cmd=\(cmd)&param=\(parameter)&sid=\(sID)"
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
extension OperationThermostat:XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentParsingElement = elementName
        if elementName == "response" {
            //print("Started parsing...")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            if currentParsingElement == "value" {
                self.paramterAnswer = foundedChar
            }
            else{
                print("gefunden statt value: \(foundedChar)")
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "response" {
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            //print("end document")
            if self.paramterAnswer != nil{
                self.delegate?.replyMainOperatorThermostat(self.paramterAnswer!)
            }
            
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
}
