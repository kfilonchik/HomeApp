//
//  Md5Maker.swift
//  Calculates a checksum of challenge and password for connecting to the fritzBox
//
//  Created by Jokto on 27.05.18.
//  Copyright © 2018 MobileAnwendungen. All rights reserved.
//

import Foundation

struct Md5Maker {
    
    func MD5(challenge: String, password: String) -> String {
        let checkSumText = challenge+"-"+password
        let messageData = checkSumText.data(using:.utf16LittleEndian)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes
            {digestBytes in
            messageData.withUnsafeBytes
                {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        let md5Hex =  digestData.map { String(format: "%02hhx", $0) }.joined()
        return challenge+"-"+md5Hex
    }
}
