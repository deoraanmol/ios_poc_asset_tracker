//
//  SignInViewController.swift
//  CalsSales
//
//  Created by Anmol Deora on 03/05/18.
//  Copyright © 2018 deoras. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var catsUsername: UITextField!
    @IBOutlet weak var catsPassword: UITextField!
    
    @IBOutlet weak var labelFooter: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelFooter.isHidden = true
    }
    
    @IBAction func webLogin(_ sender: Any) {
        
        
        
        
        let homePageController  = self.storyboard?.instantiateViewController(
            withIdentifier: "HomePageController") as! HomePageController
        self.present(homePageController, animated: true)
        
        
    }
    
}
