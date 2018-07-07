//
//  ViewController.swift
//  test
//
//  Created by Khristina Filonchik on 25.05.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//


import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var UICollectionView: UICollectionView!
    
    let reuseIdentifier = "newTile"
    let reuseIdentifier1 = "cell2"
    let items = ["Etwas","Termostat", "Schalter"]
    let aConnector = Connector()
    var toggle = false
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.items.count
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newTile", for: indexPath) as! CollectionCellViewController
        
        cell.delegate = self
        
    
        return cell
        
        /*
        if(indexPath.item > 0){
             let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionCellViewController
            /*do setup here*/
            //cell1.titel1.text = self.items[indexPath.item]
            return cell1
        }else{
             let newTile = collectionView.dequeueReusableCell(withReuseIdentifier: "newTile", for: indexPath as IndexPath) as! CollectionCellViewController
            /*do setup here*/
            
            return newTile
 */
        }
    
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
    
    /*
    func collectionView(_: UICollectionView, canPerformAction: Selector, cellForItemAt indexPath: IndexPath, withSender: Any?)  {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "testpage")
        
        self.present(viewController, animated: false, completion: nil)
    }
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UICollectionView.delegate = self
        //UICollectionView.dataSource = self
        
        let context = AppDelegate.viewContext
              let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
              let result = try? context.fetch(fetchRequest)
    
              if((result?.count)! == 0){
                       self.performSegue(withIdentifier: "mainPage", sender: self)
                   }
             else if ((result?.count)! == 1){
                       aConnector.startUpConnector()
                 }
        
        //aConnector.startUpConnector()

    }    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Show sign up page first
    override func viewDidAppear(_ animated: Bool) {

        aConnector.setSwitchState(deviceID: "08761 0437714", state: toggle)
        if (toggle == true){
                toggle = false
        }
        else if (toggle == false){
            toggle = true
        }

        
        //temp settings to have login screen
        let bla = ManageDB()
        bla.deleteAppSettings()
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dataSegue" {
            let secondViewController = segue.destination as? DetailsViewController
            if let svc = secondViewController {
                svc.data = "Hello World"
            }
        }
        
    }
}

//--//---//

extension ViewController: CollectionCellViewControllerDelegate{
    func button(addNewTile cell: CollectionCellViewController) {
        print("Hello World!")
        
        self.performSegue(withIdentifier: "dataSegue", sender: self)
        //do what you want with the cell and data
    }
}
