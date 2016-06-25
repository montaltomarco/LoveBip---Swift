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
    
    override func viewDidLoad() {
        
        userEmail = NSUserDefaults.standardUserDefaults().objectForKey("LoveBipUserEmail") as? String
        
        if let _ = connectedBLEDevice {
            self.initTouchListener()
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
    
    override func viewWillAppear(animated: Bool) {

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

    }
    
    @IBAction func signOutTapped(sender: AnyObject) {
        
        let userEmail = NSUserDefaults.standardUserDefaults().objectForKey("LoveBipUserEmail") as? String
        
        if let _ = userEmail {
            let fbManager: FBSDKLoginManager = FBSDKLoginManager()
            fbManager.logOut()
            NSUserDefaults.standardUserDefaults().removeObjectForKey("LoveBipUserEmail")
            
            self.performSegueWithIdentifier("logout_home_to_login_segue", sender: self)
            
        }
    }
}
