//
//  FaderViewController.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 20.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit

class FaderViewController: UIViewController {
    var faderverObj = FaderManager(faderValue: 0.3, scale: 1.0) {
        didSet{updateUI()}
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
            faderverObj.scale = Double((faderView?.scale)!)
        default:
            break
        }
    }
    
    @objc func changeTemp(byReactingTo panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .changed, .ended:
            faderView?.faderValue += -(panRecognizer.translation(in: faderView).y)/500
            panRecognizer.setTranslation(CGPoint(x:0,y:0), in: faderView)
            faderverObj.faderValue = Double((faderView?.faderValue)!)
        default:
            break
        }
    }
    
    
    
    private func updateUI(){
        
        faderView?.faderValue = CGFloat(faderverObj.faderValue)
        faderView?.scale = CGFloat(faderverObj.scale)
    }
    
}
