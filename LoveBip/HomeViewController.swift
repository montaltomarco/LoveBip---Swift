//
//  HomeViewController.swift
//  LoveBip
//
//  Created by Marco Montalto on 21/06/16.
//  Copyright © 2016 Marco Montalto. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class HomeViewController: UIViewController {
    
    var touchPin: MBLGPIOPin = MBLGPIOPin()
    var timerTouch: NSTimer?
    var userEmail: String?
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        
        let userPairName = NSUserDefaults.standardUserDefaults().objectForKey("userPairName") as? String
        let userFirstName = NSUserDefaults.standardUserDefaults().objectForKey("userFirstName") as? String

        if let _ = userFirstName {
            if let _ = userPairName {
                welcomeLabel.text = "Salut " + userFirstName! + ", tu es connecté avec : " + userPairName!
                if (userFirstName! == "Ludmila") {
                    welcomeLabel.text = "Salut " + userFirstName! + ", tu es connectée avec : " + userPairName!
                }
            } else {
                welcomeLabel.text = "Salut " + userFirstName! + ", connecte toi à ta moitié via les reglages"
            }
        } else {
            welcomeLabel.text = "Error, plese login again"
        }
        
        userEmail = NSUserDefaults.standardUserDefaults().objectForKey("LoveBipUserEmail") as? String
        
        if let _ = connectedBLEDevice {
            self.initTouchListener()
            
            //Listen to button pushed
            self.initButtonListener()
        }
    }
    
    func initTouchListener() {
        touchPin = (connectedBLEDevice!.gpio?.pins[0])! as! MBLGPIOPin
        touchPin.changeType = MBLPinChangeType.Rising
        touchPin.configuration = MBLPinConfiguration.Pullup
        touchPin.changeEvent.startNotificationsWithHandlerAsync({ (obj, error) in
            print("Got Touch")
            
            if let _ = self.timerTouch {
                self.timerTouch!.invalidate()
            }
            
            self.timerTouch = Utilities.setTimeoutNoRepeat(1.2, block: { () -> Void in
                self.touchPin.digitalValue.readAsync().success({ (obj) in
                    if obj.value.boolValue == true {
                        print("Touched 1.2 seconds - sending emotion")

                        if let mail = self.userEmail {
                            APIEmotions.sendEmotions(mail, completion: { (error) in
                                if(error != nil) {
                                    print(error)
                                }
                            })
                            connectedBLEDevice!.led?.flashLEDColorAsync(UIColor.blueColor(), withIntensity: 1, numberOfFlashes: 1)
                            connectedBLEDevice!.hapticBuzzer?.startHapticWithDutyCycleAsync(248, pulseWidth: 300, completion: {})
                        } else {
                            print("Error : Not connected")
                        }
                    }
                })
            })
        })
    }
    
    func initButtonListener() {
        connectedBLEDevice!.mechanicalSwitch?.switchUpdateEvent.startNotificationsWithHandlerAsync({ (result, error) in
            if let _ = result {
                print(result!.value.boolValue)
                if result!.value.boolValue == true {
                    let userEmail = NSUserDefaults.standardUserDefaults().objectForKey("LoveBipUserEmail") as? String
                    
                    if let mail = userEmail {
                        APIEmotions.sendEmotions(mail, completion: { (error) in
                            if(error != nil) {
                                print(error)
                            }
                        })
                    }
                }
            }
        })
    }
    
    @IBAction func signOutTapped(sender: AnyObject) {
        let fbManager: FBSDKLoginManager = FBSDKLoginManager()
        fbManager.logOut()
        NSUserDefaults.standardUserDefaults().removeObjectForKey("LoveBipUserEmail")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userPairName")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userFirstName")
        performSegueWithIdentifier("logout_home_to_login_segue", sender: self)
    }
}
