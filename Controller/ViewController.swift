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
    
    
    let context = AppDelegate.viewContext
    let aConnector = Connector()
    var toggle = false
    
    //item Button "addNewCell"
    @IBAction func addNewTile(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "createNewTile", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dashboardTilesRequest: NSFetchRequest<DashboardTile> = DashboardTile.fetchRequest()
        let dashboardTiles = try? context.fetch(dashboardTilesRequest)
        print("Count of tiles for collection view: \(dashboardTiles!.count)")
        print("Value of \"section\": \(section)")
        
        return dashboardTiles!.count
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dbTilesRequest: NSFetchRequest<DashboardTile> = DashboardTile.fetchRequest()
        let thermoTiles = try? context.fetch(dbTilesRequest)
        
        print("aufruf collectionView\(indexPath.item)")
        
        let aThermoTile = thermoTiles?[indexPath.item] as? ThermostatTile
        let aSwitchTile =  thermoTiles?[indexPath.item] as? SwitchTile
        if (aThermoTile != nil)
        {
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiSwitch", for: indexPath as IndexPath) as! CollectionCellViewController
            
            aCell.titel1.text = aThermoTile?.thermostat?.title
            let floatTem = aThermoTile?.thermostat?.actual_temp
            //aCell.inf1.text = String(floatTem!)//aThermoTile?.thermostat?.actual_temp)
            print("titel des Thermostats auf Kachel: \(aThermoTile?.thermostat?.title)")
            return aCell
        }
        else if (aSwitchTile != nil){
            print("Aufruf else")
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiScene", for: indexPath as IndexPath) as! CollectionCellViewController
            aCell.titleThermostatTile.text = "keineThermostatTile"
            return aCell
        }
    //Conditions of "add newTile" cell...?
        else {
             let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiNewTile", for: indexPath as IndexPath) as! CollectionCellViewController
            aCell.delegate = self
            return aCell
    }
 }

    
      
        /*
        var titles = [String]()
        print(titles)
        print("Anzahl Kacheln thermostate \(thermoTiles!.count)")
        for bla in thermoTiles!{
            titles.append((bla.thermostat?.title)!)
        }
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionCellViewController
        
        cell1.titel1.text = titles[indexPath.item]
        return cell1
 */
  
        
        /*
        if(indexPath.item > 0){
             let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionCellViewController
            /*do setup here*/
            cell1.titel1.text = self.items[indexPath.item]
            return cell1
        }else{
             let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier1, for: indexPath as IndexPath) as! CollectionCellViewController
            /*do setup here*/
            
            return cell2
        }
        
        */
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
  
    /*
    func collectionView(_: UICollectionView, canPerformAction: Selector, cellForItemAt indexPath: IndexPath, withSender: Any?)  {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "testpage")
        
        self.present(viewController, animated: false, completion: nil)
    }
*/
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            print("1")
            performSegue(withIdentifier: "showFader", sender: nil)
        default:
            break
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
       // let bla = ManageDB()
       // bla.deleteAppSettings()
        
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
//---//

extension ViewController: CollectionCellViewControllerDelegate{
    func button(addNewTile cell: CollectionCellViewController) {
        self.performSegue(withIdentifier: "createNewTile", sender: self)
    }
}
