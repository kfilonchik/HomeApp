//
//  SignUpControllerViewController.swift
//  test
//
//  Created by Khristina Filonchik on 15.06.18.
//  Copyright © 2018 Khristina Filonchik. All rights reserved.
//

import UIKit

class SignUpControllerViewController: UIViewController {

    @IBAction func Sign(_ sender: UIButton) {
    
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardView")
        
        self.present(viewController, animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dataSegue" {
            segue.destination as? ViewController
        }
    }
  
*/
}
