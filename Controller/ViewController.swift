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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let context = AppDelegate.viewContext
    let aConnector = Connector()
    let dashboardTilesRequest: NSFetchRequest<DashboardTile> = DashboardTile.fetchRequest()
    var dashboardTiles: [DashboardTile]?
    var noOfTiles: Int?
    var theCollectionView: UICollectionView?
    var faderDestination: DashboardTile?
    
    //small "+" in upper right corner
    @IBAction func addNewTile(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "createNewTile", sender: self)
    }
    
    private func configureCollectionViewLayout() {
    
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
            var aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiSwitch", for: indexPath as IndexPath) as! CollectionCellViewController
            
            aCell.layer.cornerRadius = 25.0
            aCell.layer.masksToBounds = true
            aCell.layer.shadowColor = UIColor.clear.cgColor
            aCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            aCell.layer.shadowRadius = 4.0
            aCell.layer.shadowOpacity = 1.0
            aCell.layer.masksToBounds = false
            aCell.layer.shadowPath = UIBezierPath(roundedRect: aCell.bounds, cornerRadius: aCell.contentView.layer.cornerRadius).cgPath
       
      
            aCell.titleSwitch.text = aSwitch?.title
            aCell.delegate = self
            aCell.connectedEntity = aSwitch
          
            return aCell
        }
        
        else if (aThermo != nil){
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiTermostat", for: indexPath as IndexPath) as! CollectionCellViewController
            
            aCell.layer.cornerRadius = 25.0
            aCell.layer.masksToBounds = true
            aCell.layer.shadowColor = UIColor.clear.cgColor
            aCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            aCell.layer.shadowRadius = 10.0
            aCell.layer.shadowOpacity = 1.0
            aCell.layer.masksToBounds = false
            aCell.layer.shadowPath = UIBezierPath(roundedRect: aCell.bounds, cornerRadius: aCell.contentView.layer.cornerRadius).cgPath
            
            
            aCell.thermoTileTitle.text = aThermo?.title
            if aThermo?.target_temp != nil{
                aCell.targetTemp.text = String(aThermo!.target_temp)
            }
            if aThermo?.actual_temp != nil{
                 aCell.currentTemp.text = String(aThermo!.actual_temp)
            }
            aCell.delegate = self
            aCell.connectedEntity = aThermo
            return aCell
        }
        
        else if (aSwitchGroup != nil){
            
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiSwitchGroup", for: indexPath as IndexPath) as! CollectionCellViewController
            
            
            aCell.layer.cornerRadius = 25.0
            aCell.layer.masksToBounds = true
            aCell.layer.shadowColor = UIColor.clear.cgColor
            aCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            aCell.layer.shadowRadius = 10.0
            aCell.layer.shadowOpacity = 1.0
            aCell.layer.masksToBounds = false
            aCell.layer.shadowPath = UIBezierPath(roundedRect: aCell.bounds, cornerRadius: aCell.contentView.layer.cornerRadius).cgPath
            
            
            aCell.titleSwitchGroup.text = aSwitchGroup?.title
            aCell.labelTop.text = "-1"
            aCell.labelBottom.text = "-1"
            aCell.delegate = self
            aCell.connectedEntity = aSwitchGroup
            return aCell
        }
        else if (aThermoGroup != nil){
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiTermostatGroup", for: indexPath as IndexPath) as! CollectionCellViewController
            
            
            aCell.layer.cornerRadius = 25.0
            aCell.layer.masksToBounds = true
            aCell.layer.shadowColor = UIColor.clear.cgColor
            aCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            aCell.layer.shadowRadius = 10.0
            aCell.layer.shadowOpacity = 1.0
            aCell.layer.masksToBounds = false
            aCell.layer.shadowPath = UIBezierPath(roundedRect: aCell.bounds, cornerRadius: aCell.contentView.layer.cornerRadius).cgPath
            
            
            aCell.titleThermoGroup.text = aThermoGroup?.title
            aCell.targetTempThermoGroup.text = "-1"
            aCell.thermosOnTarget.text = "-1"
            aCell.thermosNotOnTarget.text = "-1"
            aCell.delegate = self
            aCell.connectedEntity = aThermoGroup
            return aCell
        }
        else if (aScene != nil){
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiScene", for: indexPath as IndexPath) as! CollectionCellViewController
            
            aCell.layer.cornerRadius = 25.0
            aCell.layer.masksToBounds = true
            aCell.layer.shadowColor = UIColor.clear.cgColor
            aCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            aCell.layer.shadowRadius = 10.0
            aCell.layer.shadowOpacity = 1.0
            aCell.layer.masksToBounds = false
            aCell.layer.shadowPath = UIBezierPath(roundedRect: aCell.bounds, cornerRadius: aCell.contentView.layer.cornerRadius).cgPath
            
            
            aCell.titleSceneTile.text = aScene?.title
            aCell.labelLeft.text = "-1"
            aCell.labelRight.text = "-1"
            aCell.delegate = self
            aCell.connectedEntity = aScene
            return aCell
        }
    
        //Conditions of "add newTile" cell...?
        else{
             let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiNewTile", for: indexPath as IndexPath) as! CollectionCellViewController
            
            aCell.layer.cornerRadius = 25.0
            aCell.layer.masksToBounds = true
            aCell.layer.shadowColor = UIColor.clear.cgColor
            aCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            aCell.layer.shadowRadius = 10.0
            aCell.layer.shadowOpacity = 1.0
            aCell.layer.masksToBounds = false
            aCell.layer.shadowPath = UIBezierPath(roundedRect: aCell.bounds, cornerRadius: aCell.contentView.layer.cornerRadius).cgPath
            
            aCell.delegate = self
            return aCell
        }
    }
    
    //Navigation function, we need to write conditions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellObject = theCollectionView?.cellForItem(at: indexPath) as! CollectionCellViewController
        let connectedEntity = cellObject.connectedEntity
        let aThermo = connectedEntity as? Thermostat
        let aThermoGroup = connectedEntity as? ThermostatGroup
        
        if(aThermo != nil || aThermoGroup != nil){
            self.performSegue(withIdentifier: "showFader", sender: self)
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
            let width = (view.frame.width-20)/3
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.minimumLineSpacing = 10
            layout.itemSize = CGSize(width: 170, height: 170)
            collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right:10)

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
        
        if (segue.identifier == "showFader") {
            let secondViewController = segue.destination as? FaderViewController
            if let svc = secondViewController {
                svc.controlledEntity = faderDestination
            }
            //print("in prepare")
            //let destViewController = segue.destination as? FaderViewController
            }
    }
}

//---//

extension ViewController: CollectionCellViewControllerDelegate{
    
    func goToFader(entityToFade: DashboardTile) {
        //print("goToFaderGroup: \(entityToFade)")
        faderDestination = entityToFade
        self.performSegue(withIdentifier: "showFader", sender: self)
    }

    
    func switchUsed(switchedEntity: DashboardTile, state: Bool) {
        if(switchedEntity as? SwitchDevice != nil){
            let switchCast = switchedEntity as! SwitchDevice
            switchCast.state = state
            switchCast.lasteChangeByAllDevRec = false
            //print("switch Action")
        }
        else if(switchedEntity as? SwitchGroup != nil){
            let aSwitchGroup = switchedEntity as? SwitchGroup
            let switches = aSwitchGroup?.switches
            for aSwitch in switches!{
                let switchCast = aSwitch as! SwitchDevice
                switchCast.state = state
                switchCast.lasteChangeByAllDevRec = false
            }
        }
    }
    func plusButton(addNewTile cell: CollectionCellViewController) {
        self.performSegue(withIdentifier: "createNewTile", sender: self)
    }
}
