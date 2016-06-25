//
//  MenuTableViewController.swift
//  LoveBip
//
//  Created by Marco Montalto on 24/06/16.
//  Copyright © 2016 Marco Montalto. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch (indexPath.row) {
        case 1 :
            let userEmail = NSUserDefaults.standardUserDefaults().objectForKey("LoveBipUserEmail") as? String
            
            if let mail = userEmail {
                APIEmotions.sendEmotions(mail, completion: { (error) in
                    if(error != nil) {
                        print(error)
                    }
                })
            }
        default :
            print("Other case clicked")
        }
    }
}
