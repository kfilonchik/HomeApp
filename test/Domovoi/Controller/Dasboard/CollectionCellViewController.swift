//
//  CollectionCellViewControllerCollectionViewCell.swift
//  test
//
//  Created by Khristina Filonchik on 15.06.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit

class CollectionCellViewController: UICollectionViewCell {
    weak var delegate: CollectionCellViewControllerDelegate?
  

    
    @IBAction func makeNewTile(_ sender: Any) {
          delegate?.button(addNewTile: self)
    }
    
    @IBOutlet weak var titel1: UILabel!
    
    @IBOutlet weak var inf1: UILabel!
    @IBOutlet weak var inf2: UILabel!
    @IBOutlet weak var titel2: UILabel!
    
    
}

protocol CollectionCellViewControllerDelegate: class {
    func button(addNewTile cell: CollectionCellViewController)
}


