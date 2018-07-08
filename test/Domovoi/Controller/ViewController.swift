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
    
    //Button newTile
    @IBAction func NewTile(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "newTile", sender: self)
    }
    
    
    @IBOutlet weak var UICollectionView: UICollectionView!
    
   // let reuseIdentifier = "newTile"
    let reuseIdentifier1 = "cell2"
    let items = ["Etwas","Termostat", "Schalter"]
    let items2 = ["Etwas","Termostat", "Schalter"]
    let aConnector = Connector()
    var toggle = false
    let reuseIdentifier: String = ""
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.items.count
        /*
        let context = AppDelegate.viewContext
        let fetchRequest: NSFetchRequest<DashboardTile> = DashboardTile.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        
       if ((result?.count)! == 1){
            let indexPath = IndexPath(item: 3, section: 0);
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as! CollectionCellViewController
            return result!.count
       } else {
        return 0
        }
 */
    
        
      return 6
        
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newTile", for: indexPath) as! CollectionCellViewController
        
        cell.delegate = self
        
    
        return cell */
 /*
            let indexPath = IndexPath(item: 3, section: 0);
        
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as! CollectionCellViewController
            return cell

        
        */
        
        
        if(indexPath.row == 1){
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath as IndexPath) as! CollectionCellViewController
            /*do setup here*/
            //cell1.titel1.text = self.items[indexPath.item]
            return cell
        }
        else if (indexPath.row == 2){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath as IndexPath) as! CollectionCellViewController
            /*do setup here*/
            //cell1.titel1.text = self.items[indexPath.item]
            return cell
        }
        else if (indexPath.row == 3){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath as IndexPath) as! CollectionCellViewController
            /*do setup here*/
            //cell1.titel1.text = self.items[indexPath.item]
            return cell
        }
        else if (indexPath.row == 4){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell4", for: indexPath as IndexPath) as! CollectionCellViewController
            /*do setup here*/
            //cell1.titel1.text = self.items[indexPath.item]
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell5", for: indexPath as IndexPath) as! CollectionCellViewController
            return cell
            
        }
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
        //let bla = ManageDB()
        //bla.deleteAppSettings()
        
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
        
        self.performSegue(withIdentifier: "newTile", sender: self)
        //do what you want with the cell and data
    }
}


