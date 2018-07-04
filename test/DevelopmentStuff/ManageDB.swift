//
//  ManageDB.swift
//  Domovoi
//
//  Created by Jokto on 29.06.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ManageDB: UIViewController {

    let context = AppDelegate.viewContext
    let aConnector = Connector()
    //let container = AppDelegate.persistentContainer

    
    override func viewDidLoad() {
        super.viewDidLoad()
        aConnector.startUpConnector()
/*
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
  */
        NotificationCenter.default.addObserver(self, selector: #selector(observerSelector(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    }
    
    @IBAction func addWrongData(_ sender: UIButton) {
        let stdAppSettings = AppSettings(context: context)
        stdAppSettings.fritzID = "7ncvvd2irftxy2fv"
        stdAppSettings.userName = "domovoi"
        stdAppSettings.passWord = "DomoSafe2018!"
        
        do{ // persist data
            try context.save()
            
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func printBtn(_ sender: UIButton) {
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        //print(result?.count)
        if((result?.count)! > 0){
            //print(result![0].objectID)
            result![0].userName! = "domovoi"
            
        }
        
        
        do{ // persist data
            try context.save()
            
        } catch {
            print(error)
        }
        
        
    }
    
    @IBAction func deleteContentBtn(_ sender: UIButton) {
        deleteAppSettings()
    }
    
    func deleteAppSettings(){
        print("delete procedure")
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try context.execute(batchDeleteRequest)
            
        } catch {
            // Error Handling
        }
        
        context.reset()
    }
    
    @objc func observerSelector(_ notification: Notification) {

        
        let fetchRequest: NSFetchRequest<Thermostat> = Thermostat.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        
        if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>, !updatedObjects.isEmpty {
            print(" ////////inupdated ////////////")
            for bl in updatedObjects{
                
                /*let cc = bl as? Thermostat
                print("object: \(cc)")
                print("object title: \(cc?.tile)")
                print("change in Object\(bl)")*/
            }
        
        
            
        }

    }
/*
    @objc func contextObjectsDidChange(_ notification: Notification) {
        print("contextObjectsDidChanged \(notification)")
    }
    func contextWillSave(_ notification: Notification) {
        print("contextWillSave \(notification)")
    }
    func contextDidSave(_ notification: Notification) {
        print("contextDidSave \(notification)")
    }

 */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
