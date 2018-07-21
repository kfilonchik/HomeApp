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
    let dashboardTilesRequest: NSFetchRequest<DashboardTile> = DashboardTile.fetchRequest()
    var dashboardTiles: [DashboardTile]?
    var noOfTiles: Int?
    var theCollectionView: UICollectionView?
    
    @IBAction func addNewTile(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "createNewTile", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        theCollectionView = collectionView
        dashboardTilesRequest.predicate = NSPredicate(format: "onDashboard == true")
        dashboardTiles = try? context.fetch(dashboardTilesRequest)
        noOfTiles = dashboardTiles!.count
        return dashboardTiles!.count + 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        theCollectionView = collectionView
        var aSwitch: SwitchDevice?
        var aThermo: Thermostat?
        var aSwitchGroup: SwitchGroup?
        var aThermoGroup: ThermostatGroup?
        var aScene: Scene?
        
        if (indexPath.item < noOfTiles!){
            aSwitch         = dashboardTiles?[indexPath.item] as? SwitchDevice
            aThermo         = dashboardTiles?[indexPath.item] as? Thermostat
            aSwitchGroup    = dashboardTiles?[indexPath.item] as? SwitchGroup
            aThermoGroup    = dashboardTiles?[indexPath.item] as? ThermostatGroup
            aScene          = dashboardTiles?[indexPath.item] as? Scene
        }
        
        
        if (aSwitch != nil)
        {
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiSwitch", for: indexPath as IndexPath) as! CollectionCellViewController
            
            aCell.titleSwitch.text = aSwitch?.title
            
            return aCell
        }
        
        else if (aThermo != nil){
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiTermostat", for: indexPath as IndexPath) as! CollectionCellViewController
            //aCell..text = aThermo?.title
            return aCell
        }
        
        else if (aSwitchGroup != nil){
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiSwitchGroup", for: indexPath as IndexPath) as! CollectionCellViewController
            //aCell.titleThermostatTile.text = aSwitchGroup?.title
            return aCell
        }
        else if (aThermoGroup != nil){
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiTermostatGroup", for: indexPath as IndexPath) as! CollectionCellViewController
            //aCell.titleThermostatTile.text = aThermoGroup?.title
            return aCell
        }
        else if (aScene != nil){
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiScene", for: indexPath as IndexPath) as! CollectionCellViewController
            //aCell.titleThermostatTile.text = aScene?.title
            return aCell
        }
    
        //Conditions of "add newTile" cell...?
        else{
             let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiNewTile", for: indexPath as IndexPath) as! CollectionCellViewController
            aCell.delegate = self
            return aCell
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

    }    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Show sign up page first
    override func viewDidAppear(_ animated: Bool) {
        dashboardTiles = try? context.fetch(dashboardTilesRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dashboardTiles = try? context.fetch(dashboardTilesRequest)
        if theCollectionView != nil{
            self.theCollectionView!.reloadData()
        }
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
