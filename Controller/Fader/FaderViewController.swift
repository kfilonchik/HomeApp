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
    
    var faderValue: CGFloat? {didSet {updateUI()}}
    var scale: CGFloat? {didSet {updateUI()}}
    var aThermoGroup: ThermostatGroup?
    var aThermostat: Thermostat?
    var controlledEntity: DashboardTile? {
        didSet{
            aThermostat = controlledEntity as? Thermostat
            aThermoGroup = controlledEntity as? ThermostatGroup
            faderValue = 0.5 // Add logic here

        }
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
            faderValue = faderView?.faderValue
        case .ended:
            faderView?.faderValue += -(panRecognizer.translation(in: faderView).y)/500
            panRecognizer.setTranslation(CGPoint(x:0,y:0), in: faderView)
            faderValue = faderView?.faderValue
            performOperation(targetTemp: Float(faderValue!))
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
    }
    
    func performOperation(targetTemp: Float){
        print(targetTemp)
        if(aThermoGroup != nil){
            print("it is a group")
            let thermostats = aThermoGroup?.thermostats
            for aThermo in thermostats!{
                let thermo = aThermo as? Thermostat
                thermo?.target_temp = 22.2 //add logic here
            }
        }
        if(aThermostat != nil){
            print("it is a thermostat")
            aThermostat?.target_temp = 22.2 // add logic here
            
        }
        
        // add context Save here
        
    }
    
}
