//
//  RequesterDelegate.swift
//
//
//  Created by Jokto on 28.05.18.
//  Copyright © 2018 MobileAnwendungen. All rights reserved.
//

import Foundation

protocol RequesterDelegate {
    func transferSID(_ sessionID: String)
    func refreshSID()
    func replyMainOperatorThermostat(_ reply: String)
    func replyDeviceList(_ deviceList:[[String: String]])
}
