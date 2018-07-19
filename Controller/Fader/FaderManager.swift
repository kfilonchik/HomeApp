//
//  FaderManager.swift
//  Domovoi
//
//  Created by Khristina Filonchik on 20.07.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import Foundation

struct FaderManager {
    
    var faderValue = 0.0 {
        didSet{
            print(faderValue)
        }
    }
    var scale = 1.0
}
