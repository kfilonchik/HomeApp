//
//  FaderViewController.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 20.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit

class FaderViewController: UIViewController {
    
    var faderValue: CGFloat? {didSet {updateUI()}}
    var scale: CGFloat? {didSet {updateUI()}}
    var controlledEntity: DashboardTile? {
        didSet{
            print("controlledEntity: \(controlledEntity)")
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
        case .changed, .ended:
            faderView?.faderValue += -(panRecognizer.translation(in: faderView).y)/500
            panRecognizer.setTranslation(CGPoint(x:0,y:0), in: faderView)
            faderValue = faderView?.faderValue
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
        print("controlledEntity: \(controlledEntity)")
    }
    
}
