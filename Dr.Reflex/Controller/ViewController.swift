//
//  ViewController.swift
//  Dr.Reflex
//
//  Created by priyanka gayathri on 30/08/20.
//  Copyright © 2020 priyanka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var logInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "logIn") {
            //UserDefaults.standard.set("doctor", forKey: "Type")
            
            if UserDefaults.standard.string(forKey: "Type") == "doctor" {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "doctorContactList")
                self.navigationController?.pushViewController(mainTabBarController, animated: false)
                
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "LoginUser")
                self.navigationController?.pushViewController(mainTabBarController, animated: false)
            }
        } else {
            
            registerButton.layer.masksToBounds = true
            
            
        }
    }
    
}

