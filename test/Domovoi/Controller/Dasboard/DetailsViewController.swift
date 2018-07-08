//
//  DetailsViewController.swift
//  test
//
//  Created by Khristina Filonchik on 31.05.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    
    @IBOutlet weak var UICollectionView1: UICollectionView!
    @IBOutlet weak var UICollectionView2: UICollectionView!
    
    @IBOutlet weak var UICollectionView3: UICollectionView!
    
    
    
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
