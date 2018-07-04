//
//  ModelExecutor.swift
//  Domovoi
//
//  Created by Jokto on 04.07.18.
//  Copyright © 2018 Mathis Aubert. All rights reserved.
//



import UIKit
import Foundation
import CoreData

class ModelExecutor {
    
    let context = AppDelegate.viewContext
    var delegate: RequesterDelegate?
    
    
    func startUp(_ theConnector: RequesterDelegate){
        print("Model Exexutor started")
        delegate = theConnector
        NotificationCenter.default.addObserver(self, selector: #selector(observerSelector(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        }
    
    
    @objc func observerSelector(_ notification: Notification) {
        
        
        let fetchRequestThermostat: NSFetchRequest<Thermostat> = Thermostat.fetchRequest()
        let fetchRequestSwitch: NSFetchRequest<SwitchDevice> = SwitchDevice.fetchRequest()
        
        if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>, !updatedObjects.isEmpty {
            for aDevice in updatedObjects{
                let aSwitch = aDevice as? SwitchDevice
                let aThermostat = aDevice as? Thermostat
                
                if(aSwitch != nil && delegate != nil && aSwitch?.state != nil){
                    
                    if(aSwitch?.lasteChangeByAllDevRec != true){
                        delegate!.taskFromModelExecutorSwitch(id: aSwitch!.id!, state: aSwitch!.state)
                        print("SwitchOperation aus Model Executor ausgelöst")
                    }
                }
                
                if(aThermostat != nil && delegate != nil && aThermostat?.target_temp != nil){
                    
                    if(aThermostat?.lasteChangeByAllDevRec != true){
                        delegate!.taskFromModelExecutorThermostat(id: aThermostat!.id!, temperature: aThermostat!.target_temp)
                        print("aThermostatOperation aus Model Executor ausgelöst")
                    }
                    //
                }
            }
        }
    }
}


