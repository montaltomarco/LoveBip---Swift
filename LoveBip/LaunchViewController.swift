//
//  LaunchViewController.swift
//  LoveBip
//
//  Created by Marco Montalto on 15/06/16.
//  Copyright © 2016 Marco Montalto. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LaunchViewController: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let userEmail = NSUserDefaults.standardUserDefaults().objectForKey("LoveBipUserEmail") as? String
        if let _ = userEmail {
            print("\n Already logged in \n")
            self.performSegueWithIdentifier("launch_to_home_segue", sender: self)
        } else {
            self.performSegueWithIdentifier("launch_to_login_segue", sender: self)
        }
    }    
}
