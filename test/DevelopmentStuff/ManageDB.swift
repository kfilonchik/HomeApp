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
        print("didload")
    }
//

    
//
    
    
    
    
    
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
        /*result![0].fritzID! = "neuespasswort"
        print(result![0].fritzID!)
        
        do{ // persist data
            try context.save()
            
        } catch {
            print(error)
        } */
        
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
