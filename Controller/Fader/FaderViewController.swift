//
//  FaderViewController.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 20.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit
import CoreData

class FaderViewController: UIViewController {
    
    
    let context = AppDelegate.viewContext
    var faderValue: CGFloat? {didSet {updateUI()}}
    var scale: CGFloat? {didSet {updateUI()}}
    var aThermoGroup: ThermostatGroup?
    var aThermostat: Thermostat?
    var controlledEntity: DashboardTile? {
        didSet{
            aThermostat = controlledEntity as? Thermostat
            aThermoGroup = controlledEntity as? ThermostatGroup
            
            if(aThermostat != nil){
                //print("aThermo")
                faderValue = calculateFaderValue((aThermostat?.target_temp)!)

            }
            
            if(aThermoGroup != nil){
                //print("aThermGroup")
                faderValue = calculateFaderValue((aThermoGroup?.target_temp)!)
            }
            
        }
    }
    
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var entityTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entityTitle.text = controlledEntity?.title
    }
    
    @IBOutlet weak var faderView: FaderView!{
        didSet{
            let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(changeScale(byReactingTo:)))
            faderView.addGestureRecognizer(pinchRecognizer)
            let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(changeTemp(byReactingTo:)))
            faderView.addGestureRecognizer(panRecognizer)
            updateUI()
        }
    }
    
    @objc func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed, .ended:
            faderView?.scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
            scale = faderView?.scale
        default:
            break
        }
    }
    
    @objc func changeTemp(byReactingTo panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .changed:
            faderView?.faderValue += -(panRecognizer.translation(in: faderView).y)/500
            panRecognizer.setTranslation(CGPoint(x:0,y:0), in: faderView)
            
            
            
            
        case .ended:
            faderView?.faderValue += -(panRecognizer.translation(in: faderView).y)/500
            panRecognizer.setTranslation(CGPoint(x:0,y:0), in: faderView)
            faderValue = faderView?.faderValue
            doChangeAfterFingerUp(targetTemp: Float(faderValue!))
        default:
            break
        }
    }

    private func updateUI(){
        if(faderValue != nil){
            faderView?.faderValue = faderValue!
        }
        if(scale != nil){
            faderView?.scale = scale!
        }
        if(faderValue != nil && currentTempLabel != nil){
             currentTempLabel.text = temperatureCalculationForGUI(faderValue!)
        }
       
    }
    
    func doChangeAfterFingerUp(targetTemp: Float){
        //print(targetTemp)
        if(aThermoGroup != nil){
            //print("it is a group")
            let thermostats = aThermoGroup?.thermostats
            for aThermo in thermostats!{
                let thermo = aThermo as? Thermostat
                thermo?.target_temp = calculateTemperature(faderValue!)
                thermo?.lasteChangeByAllDevRec = false
            }
            aThermoGroup?.target_temp = calculateTemperature(faderValue!)
        }
        if(aThermostat != nil){
            //print("it is a thermostat")
            aThermostat?.target_temp = calculateTemperature(faderValue!)
            aThermostat?.lasteChangeByAllDevRec = false
            
        }
        
        do{ // persist data
            try context.save()
            
        } catch {
            print(error)
        }
        
    }
    //Scale Value from temperatures in Fritz format from 0 to 1
    func calculateFaderValue(_ value: Float) -> CGFloat{ //Converts
        var response: Float?
        if(value == 254){response = 1}
        else if (value == 253) {response = 0}
        else {response = ((value - 8) / (20))}
        return CGFloat(response!)
    }
    
    //Scale Value from Fader (0 <-> 1) to 253,254 and 8 <-> 28
    func calculateTemperature(_ value: CGFloat) -> Float{
        var response: Float?
        if(value == 1){response = 254}
        else if (value == 0) {response = 253}
        else {response =  (Float(value) * 20) + 8 }
        return response!
    }
    
    func temperatureCalculationForGUI(_ theTemp: CGFloat) -> String{
        var result = ""
        let tempfrFad = calculateTemperature(theTemp)
        switch calculateTemperature(theTemp){
            case 254.0: result = "On"
            case 253.0: result = "Off"
            default: result = String(roundf(tempfrFad * 2)/2)
        }
        return result
    }

    
}
