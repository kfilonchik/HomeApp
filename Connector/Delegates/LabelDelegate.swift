//
//  LabelDelegate.swift
//  httpRequest
//
//  Created by Jokto on 28.05.18.
//  Copyright © 2018 MobileAnwendungen. All rights reserved.
//

import Foundation

protocol LabelDelegate {
    func addLongTex(value:String)
    func addTemp(value:String)
    func currentDeviceStateList(_ deviceList: [[String : String]])
}
