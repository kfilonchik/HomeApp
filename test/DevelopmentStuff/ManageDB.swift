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

    let context_writer = AppDelegate.viewContext
    let context_reader = AppDelegate.viewContext
    //let container = AppDelegate.persistentContainer
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("didload")
    }
//

    
//
    
    
    
    
    
    @IBAction func addWrongData(_ sender: UIButton) {
        let stdAppSettings = AppSettings(context: context_writer)
        stdAppSettings.fritzID = "wrong"
        stdAppSettings.userName = "falsch"
        stdAppSettings.passWord = "faux"
        
        do{ // persist data
            try context_writer.save()
            
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func printBtn(_ sender: UIButton) {
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        let result = try? context_reader.fetch(fetchRequest)
        for aresult in result!{
            print(aresult.fritzID)
            print(aresult.userName)
            print(aresult.passWord)
        }
    }
    
    @IBAction func deleteContentBtn(_ sender: UIButton) {

        print("delete procedure")
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
         
         // Create Batch Delete Request
         let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
         
         do {
         try context_writer.execute(batchDeleteRequest)
         
         } catch {
         // Error Handling
         }
        
        context_writer.reset()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
