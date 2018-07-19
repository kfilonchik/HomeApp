//
//  FaderView.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 20.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit

@IBDesignable
class FaderView: UIView
{
    @IBInspectable
    var scale: CGFloat = 0.8{
        didSet {
            setNeedsDisplay()
            if(scale > 1.5){
                scale = 1.5
            }
            else if(scale < 0.3){
                scale = 0.3
            }
        }
        
    }
    @IBInspectable
    var faderValue: CGFloat = 0.5  {
        didSet {
            setNeedsDisplay()
            if(faderValue > 1.0){
                faderValue = 1.0
            }
            else if(faderValue < 0.0){
                faderValue = 0.0
            }
        }
        
    }
    var offsLR: CGFloat = 80
    var offsTB: CGFloat = 100
    @IBInspectable
    var radius: CGFloat = 20
    @IBInspectable
    var lineWithFrame: CGFloat = 3
    
    
    
    
    private func pathForFader() -> UIBezierPath
    {
        let fWidth =  (bounds.maxX - (offsLR * 2)) * scale
        let fHeight = (bounds.maxY - (offsTB * 2)) * scale
        let posX = bounds.midX - ((fWidth  / 2))
        let posY = bounds.midY - ((fHeight / 2))
        
        let faderOrigin = CGPoint(x: posX, y: posY)
        let rectSize = CGSize(width: fWidth, height: fHeight)
        let frameRect = CGRect(origin: faderOrigin, size: rectSize)
        let pathForFader = UIBezierPath(roundedRect: frameRect, cornerRadius: radius * scale)
        pathForFader.lineWidth = lineWithFrame
        return pathForFader
    }
    
    private func pathForTempInFader() -> UIBezierPath
    {
        let fWidth =  (bounds.maxX - (offsLR * 2)) * scale
        var fHeight = (bounds.maxY - (offsTB * 2)) * scale
        let posX = bounds.midX - ((fWidth  / 2))
        let posY = bounds.midY - ((fHeight / 2)) + fHeight - fHeight * faderValue
        fHeight = fHeight * faderValue
        
        
        let faderOrigin = CGPoint(x: posX, y: posY)
        let rectSize = CGSize(width: fWidth, height: fHeight)
        let frameRect = CGRect(origin: faderOrigin, size: rectSize)
        let pathForFader = UIBezierPath(roundedRect: frameRect, cornerRadius: radius * scale)
        pathForFader.lineWidth = lineWithFrame
        return pathForFader
    }
    
    override func draw(_ rect: CGRect)
    {
        //UIColor.green.setFill()
        UIColor.red.set()
        let theFaderValue = pathForTempInFader()
        //theFaderValue.stroke()
        theFaderValue.fill()
        
        
        UIColor.blue.set()
        pathForFader().stroke()
    }
}
