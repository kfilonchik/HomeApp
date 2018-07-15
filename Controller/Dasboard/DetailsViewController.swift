//
//  DetailsViewController.swift
//  test
//
//  Created by Khristina Filonchik on 31.05.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var data: String?
    @IBOutlet weak var dataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Second View"
        
        if let concreteData = data {
            dataLabel.text = concreteData
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
