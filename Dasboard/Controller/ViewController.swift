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
    

    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let context = AppDelegate.viewContext
    let aConnector = Connector()
    let dashboardTilesRequest: NSFetchRequest<DashboardTile> = DashboardTile.fetchRequest()
    var dashboardTiles: [DashboardTile]?
    var noOfTiles: Int?
    var theCollectionView: UICollectionView?
    var faderDestination: DashboardTile?
    var nextOrder: Int16 = 0
    var redo: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        print("in View Will apper ViewController")
        dashboardTiles = try? context.fetch(dashboardTilesRequest)
        if theCollectionView != nil{
            self.theCollectionView!.reloadData()
        }
        
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        if((result?.count)! == 1 && redo == false){
            aConnector.startUpFromGUI()
            redo = true
        }
        
    }

    override func viewDidLoad() {
        print("in did load view controller")
        super.viewDidLoad()
        
        //let context = AppDelegate.viewContext
        let fetchRequest: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        
        if((result?.count)! == 0){
            print("goto login")
            self.performSegue(withIdentifier: "mainPage", sender: self)
        }
        else if ((result?.count)! == 1){
            print("regular startup with settings")
            //aConnector.startUpConnector()
        }
        
        let itemSize = UIScreen.main.bounds.width / 2 - 20
        print(itemSize)
        
        //Tiles Layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 5
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right:10)
        
        //For Drag and Drop
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        theCollectionView = collectionView
        dashboardTilesRequest.predicate = NSPredicate(format: "onDashboard == true")
        let sort = NSSortDescriptor(key: #keyPath(DashboardTile.order), ascending: true)
        dashboardTilesRequest.sortDescriptors = [sort]
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
        
        
        if (indexPath.item < noOfTiles!){ //last tile is the "+"

            aSwitch         = dashboardTiles?[indexPath.item] as? SwitchDevice
            aThermo         = dashboardTiles?[indexPath.item] as? Thermostat
            aSwitchGroup    = dashboardTiles?[indexPath.item] as? SwitchGroup
            aThermoGroup    = dashboardTiles?[indexPath.item] as? ThermostatGroup
            aScene          = dashboardTiles?[indexPath.item] as? Scene

        }
        
        if (aSwitch != nil)
        {
            var aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiSwitch", for: indexPath as IndexPath) as! CollectionCellViewController
            
            aCell = cellDesigner(aCell)
           
            aCell.uiSwitchTile.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            aCell.titleSwitch.text = aSwitch?.title
            aCell.delegate = self
            aCell.connectedEntity = aSwitch
            aCell.uiSwitchTile.isOn = (aSwitch?.state)!
          
            return aCell
        }
        
        else if (aThermo != nil){
            var aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiTermostat", for: indexPath as IndexPath) as! CollectionCellViewController
            
            aCell = cellDesigner(aCell)

            aCell.thermoTileTitle.text = aThermo?.title
            if aThermo?.target_temp != nil{
                aCell.targetTemp.text = temperatureCalculationForGUI(aThermo!.target_temp)
            }
            if aThermo?.actual_temp != nil{
                 aCell.currentTemp.text = temperatureCalculationForGUI(aThermo!.actual_temp)
            }
            aCell.delegate = self
            aCell.connectedEntity = aThermo
            
        
            return aCell
        }
        
        else if (aSwitchGroup != nil){
            
            var aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiSwitchGroup", for: indexPath as IndexPath) as! CollectionCellViewController
            
            aCell.uiSwitchGroup.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)

            
            aCell = cellDesigner(aCell)
            aCell.titleSwitchGroup.text = aSwitchGroup?.title
            
            var ons = 0
            var offs = 0
            let count = aSwitchGroup?.switches?.count
            
            for aSwitch in (aSwitchGroup?.switches)!{
                let pars = aSwitch as! SwitchDevice
                if pars.state == false{offs += 1}
                else{ons += 1}
            }
            aCell.uiSwitchGroup.isEnabled = false
            var image = UIImage(named: "x-button")
            
            if(ons == 0){
                aCell.uiSwitchGroup.isOn = false
            }
            if(offs == 0){
                aCell.uiSwitchGroup.isOn = true
            }
            if (offs == count && aSwitchGroup?.state == false){
                aCell.uiSwitchGroup.isEnabled = true
                image = UIImage(named: "verification-checkmark-symbol-in-black-circular-button-2")
            }
            if (ons == count && aSwitchGroup?.state == true){
                aCell.uiSwitchGroup.isEnabled = true
                image = UIImage(named: "verification-checkmark-symbol-in-black-circular-button-2")
            }
            aCell.uiImageOfTileSwitchGroup.image = image
            aCell.labelTop.text = String(ons)
            aCell.labelBottom.text = String(offs)
            aCell.delegate = self
            aCell.connectedEntity = aSwitchGroup
            
            
            return aCell
        }
        else if (aThermoGroup != nil){
            var aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiTermostatGroup", for: indexPath as IndexPath) as! CollectionCellViewController
            
            aCell = cellDesigner(aCell)
            
            
            
            //condition of active/non-active image
            /*
            if ((aThermo?.partOfGroups) != nil) {
             let image = UIImage(named: "verification-checkmark-symbol-in-black-circular-button-2")
             
             aCell.uiImageOfThermostatGroup.image = image
            }
            */
            
            var min:Float = 100
            var max:Float = 0
            
            for aThermo in (aThermoGroup?.thermostats)! {
                let aThermoC = aThermo as! Thermostat
                let currTemp = aThermoC.actual_temp
                if(currTemp > max){
                    max = currTemp
                }
                if(currTemp < min){
                    min = currTemp
                }
            }
            let target = aThermoGroup?.target_temp
            if((min >= target! - 1) && (max <= target! + 1)){
                let image = UIImage(named: "verification-checkmark-symbol-in-black-circular-button-2")
                aCell.uiImageOfThermostatGroup.image = image
            }
            
            
            aCell.titleThermoGroup.text = aThermoGroup?.title
            aCell.targetTempThermoGroup.text = temperatureCalculationForGUI(aThermoGroup!.target_temp)
            aCell.thermosOnTarget.text = temperatureCalculationForGUI(min)
            aCell.thermosNotOnTarget.text = temperatureCalculationForGUI(max)
            aCell.delegate = self
            aCell.connectedEntity = aThermoGroup
            return aCell
        }
        else if (aScene != nil){
            var aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiScene", for: indexPath as IndexPath) as! CollectionCellViewController
            
            aCell = cellDesigner(aCell)
            
            
            aCell.uiSwitchOfScene.isEnabled = false
            aCell.uiStatusOfScene.backgroundColor = UIColor.orange
            aCell.uiStatusOfScene.layer.cornerRadius = 8.0
            
            var swChecker = true
            var thChecker = true
            
            //Check all Switches
            for aSwitch in (aScene?.switchDevices)!{

                let scenSetSwitchesReq: NSFetchRequest<SceneSwitchSetting> = SceneSwitchSetting.fetchRequest()
                scenSetSwitchesReq.predicate = NSPredicate(format: "scene == %@ AND switchDevice == %@", (aScene?.objectID)!, ((aSwitch as AnyObject).objectID)!)
                let scenSetSwitches = try? context.fetch(scenSetSwitchesReq)

                if(scenSetSwitches![0].state != (aSwitch as AnyObject).state){
                    swChecker = false
                }
            }
            
            //Check all Thermos
            for aThermo in (aScene?.thermostats)!{
                
                let scenSetThermoReq: NSFetchRequest<SceneThermostatSetting> = SceneThermostatSetting.fetchRequest()
                scenSetThermoReq.predicate = NSPredicate(format: "scene == %@ AND thermostat == %@", (aScene?.objectID)!, ((aThermo as AnyObject).objectID)!)
                let scenSetThermos = try? context.fetch(scenSetThermoReq)
            
                if(  (scenSetThermos![0].target_temp + 1 <= (aThermo as AnyObject).target_temp)  ||
                     (scenSetThermos![0].target_temp - 1 >= (aThermo as AnyObject).target_temp)   )
                {
                    thChecker = false
                }
            }
            
            if(swChecker == true && thChecker == true){
                print("")
                aCell.uiSwitchOfScene.isEnabled = false
                aCell.uiStatusOfScene.backgroundColor = UIColor.green
                aCell.uiStatusOfScene.layer.cornerRadius = 8.0
            }
           
            aCell.titleSceneTile.text = aScene?.title
            let noTher = aScene?.thermostats?.count
            let noSw = aScene?.switchDevices?.count
            aCell.labelLeft.text = String(noTher!)
            aCell.labelRight.text = String(noSw!)
            aCell.delegate = self
            aCell.connectedEntity = aScene
            return aCell
        }

        else{
             var aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uiNewTile", for: indexPath as IndexPath) as! CollectionCellViewController
            
            aCell = cellDesigner(aCell)
            
            aCell.delegate = self
            return aCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //print("Starting Index: \(sourceIndexPath.item)")
        //print("Ending Index: \(destinationIndexPath.item)")
        let start   = sourceIndexPath.item
        let end     = destinationIndexPath.item
        var newPos: Int?
        
        //store drap and drop
        if(start + end == 1){
            if((dashboardTiles?.count)! > 1){
                dashboardTiles![start].order = Int16(end)
                dashboardTiles![end].order   = Int16(start)
            }
        }
        
        else if(start != noOfTiles && end != noOfTiles){ //+ cell is not moveable
            
            for aTile in dashboardTiles!{
                if(aTile.order <= end && aTile.order > start && aTile.order != start && start < end){ // forward
                    newPos = end
                    aTile.order -= 1
                }
                else if(aTile.order >= end && aTile.order < start && aTile.order != start && start > end){ // move backwards
                    newPos = end
                    aTile.order += 1
                }
            }
            dashboardTiles![start].order = Int16(newPos!)
        }
        do{try context.save()} catch {print(error)}
    }
    
    //Navigation function, we need to write conditions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellObject = theCollectionView?.cellForItem(at: indexPath) as! CollectionCellViewController
        let connectedEntity = cellObject.connectedEntity
        let aThermo = connectedEntity as? Thermostat
        let aThermoGroup = connectedEntity as? ThermostatGroup
        
        if(aThermo != nil || aThermoGroup != nil){
            //self.performSegue(withIdentifier: "showFader", sender: self)
        }
    }
    

    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView))  else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)

        case .changed:

            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            
            collectionView.endInteractiveMovement()
    
            self.collectionView.reloadData()

        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        dashboardTiles = try? context.fetch(dashboardTilesRequest)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showFader") {
            let secondViewController = segue.destination as? FaderViewController
            if let svc = secondViewController {
                svc.controlledEntity = faderDestination
            }
        }
    }
    
    func cellDesigner(_ inputCell: CollectionCellViewController)-> CollectionCellViewController{
        let aCell = inputCell
        aCell.layer.cornerRadius = 25.0
        aCell.layer.shadowColor = UIColor.clear.cgColor
        aCell.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        aCell.layer.shadowRadius = 4.0
        aCell.layer.shadowOpacity = 0.3
        aCell.layer.masksToBounds = false
        aCell.layer.shadowPath = UIBezierPath(roundedRect: aCell.bounds, cornerRadius: aCell.contentView.layer.cornerRadius).cgPath
        return aCell
    }
}

//---//

extension ViewController: CollectionCellViewControllerDelegate{
    func activateAScene(aScene: DashboardTile) {
        print("inEvent")
        let theScene = aScene as! Scene
        //get Swichtes
        let theScSw = theScene.switchDevices
        let theScTh = theScene.thermostats
        
        for aSwitch in theScSw!{
            let aRequ: NSFetchRequest<SceneSwitchSetting> = SceneSwitchSetting.fetchRequest()
            aRequ.predicate = NSPredicate(format: "scene == %@ AND switchDevice == %@", (theScene.objectID), ((aSwitch as AnyObject).objectID)!)
            let result = try? context.fetch(aRequ)
            (aSwitch as! SwitchDevice).state = result![0].state
            (aSwitch as! SwitchDevice).lasteChangeByAllDevRec = false
            do{try context.save()} catch {print(error)}
        }
        
        for aThermo in theScTh!{
            let aRequ: NSFetchRequest<SceneThermostatSetting> = SceneThermostatSetting.fetchRequest()
            aRequ.predicate = NSPredicate(format: "scene == %@ AND thermostat == %@", (theScene.objectID), ((aThermo as AnyObject).objectID)!)
            let result = try? context.fetch(aRequ)
            (aThermo as! Thermostat).target_temp = result![0].target_temp
            (aThermo as! Thermostat).lasteChangeByAllDevRec = false
            do{try context.save()} catch {print(error)}
        }
        
        do{try context.save()} catch {print(error)}
        self.theCollectionView!.reloadData()
    }
    

    func handleGroupSwitch(toggledEntity: DashboardTile) {
        if(toggledEntity as? SwitchGroup != nil){
            let switchGrCast = toggledEntity as! SwitchGroup
            switchGrCast.state = !switchGrCast.state
            
            for aSwitch in switchGrCast.switches!{
                let aSwitchC = aSwitch as! SwitchDevice
                aSwitchC.state = switchGrCast.state
                aSwitchC.lasteChangeByAllDevRec = false
            }
        }
        self.theCollectionView!.reloadData()
    }
    
    
    func goToFader(entityToFade: DashboardTile) {
        //print("goToFaderGroup: \(entityToFade.title)")
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
        self.theCollectionView!.reloadData()
    }
    
    func plusButton(addNewTile cell: CollectionCellViewController) {
        self.performSegue(withIdentifier: "createNewTile", sender: self)
    }
    
    func temperatureCalculationForGUI(_ theTemp: Float) -> String{
        var result = ""
        switch theTemp{
        case 254: result = "On"
        case 253: result = "Off"
        default: result = String(roundf(theTemp * 2)/2)
        }
        return result
    }
}
