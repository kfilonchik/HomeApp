//
//  ViewController.swift
//  test
//
//  Created by Khristina Filonchik on 25.05.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//


import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseIdentifier = "cell1"
    
    let reuseIdentifier1 = "cell2"
    let items = ["Etwas","Termostat", "Schalter"]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(indexPath.item > 0){
             let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionCellViewController
            /*do setup here*/
            cell1.titel1.text = self.items[indexPath.item]
            return cell1
        }else{
             let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier1, for: indexPath as IndexPath) as! CollectionCellViewController
            /*do setup here*/
            
            return cell2
        }
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
    }
    /*
    func collectionView(_: UICollectionView, canPerformAction: Selector, cellForItemAt indexPath: IndexPath, withSender: Any?)  {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "testpage")
        
        self.present(viewController, animated: false, completion: nil)
        
    }
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Show firstly sign up page
    override func viewDidAppear(_ animated: Bool) {
        
        let isUserLogged = UserDefaults.standard.bool(forKey: "isLogged")

        if(!isUserLogged){

        self.performSegue(withIdentifier: "mainPage", sender: self)
        
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dataSegue" {
            let secondViewController = segue.destination as? DetailsViewController
            if let svc = secondViewController {
                svc.data = "Hello World"
            }
        }
        
    }
}

