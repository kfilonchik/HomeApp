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
    //let container = AppDelegate.persistentContainer

    
    override func viewDidLoad() {
        super.viewDidLoad()

            NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
            NotificationCenter.default.addObserver(self, selector: #selector(observerSelector(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    }
    
    @IBAction func addWrongData(_ sender: UIButton) {
        let stdAppSettings = AppSettings(context: context)
        stdAppSettings.fritzID = "wrong"
        stdAppSettings.userName = "falsch"
        stdAppSettings.passWord = "faux"
        
        do{ // persist data
            try context.save()
            
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func printBtn(_ sender: UIButton) {
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        print(result?.count)
        if((result?.count)! > 0){
            print(result![0].fritzID!)
            print(result![0].userName!)
            print(result![0].passWord!)
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
        print("in function")
        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>, !insertedObjects.isEmpty {
            //print(insertedObjects)
        }
        if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>, !updatedObjects.isEmpty {
            print(updatedObjects)
        }
        if let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject>, !deletedObjects.isEmpty {
            //print(deletedObjects)
        }
        if let refreshedObjects = notification.userInfo?[NSRefreshedObjectsKey] as? Set<NSManagedObject>, !refreshedObjects.isEmpty {
            //print(refreshedObjects)
        }
        if let invalidatedObjects = notification.userInfo?[NSInvalidatedObjectsKey] as? Set<NSManagedObject>, !invalidatedObjects.isEmpty {
            //print(invalidatedObjects)
        }
        if let areInvalidatedAllObjects = notification.userInfo?[NSInvalidatedAllObjectsKey] as? Bool {
            //print(areInvalidatedAllObjects)
        }
    }
    
    @objc func contextObjectsDidChange(_ notification: Notification) {
        //print(notification)
    }
    func contextWillSave(_ notification: Notification) {
        print(notification)
    }
    func contextDidSave(_ notification: Notification) {
        print(notification)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
