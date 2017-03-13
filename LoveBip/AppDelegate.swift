//
//  AppDelegate.swift
//  LoveBip
//
//  Created by Marco Montalto on 09/06/16.
//  Copyright © 2016 Marco Montalto. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        
        // Override point for customization after application launch.
        let pushNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        
        application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var deviceTokenString = String(format: "%@", deviceToken).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        deviceTokenString = deviceTokenString.stringByReplacingOccurrencesOfString(" ", withString: "", options: .LiteralSearch, range: nil)
        
        NSUserDefaults.standardUserDefaults().setObject(deviceTokenString, forKey: "LoveBipDeviceToken")
        
        print("Did Register With Device Token = \(deviceTokenString)")
        
        let userEmail = NSUserDefaults.standardUserDefaults().objectForKey("LoveBipUserEmail") as? String
        
        if let userEmail = userEmail {
            // REGISTER FOR NOTIFICATIONS
            /*APILoginSignup.registerForNotifications(userEmail, deviceToken: deviceTokenString, completion:{ (error) in
            })*/
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Did Fail To Register For Remote Notifications With Error")
        print("\(error), \(error.localizedDescription)");
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        completionHandler(.NoData)
        
        print("Did Receive Remote Notification With Handler")
        
        application.applicationIconBadgeNumber = 0;
        
        let state = UIApplication.sharedApplication().applicationState.rawValue
        NSUserDefaults.standardUserDefaults().setObject(state, forKey: "LoveBipNotificationState")
    NSNotificationCenter.defaultCenter().postNotificationName("LoveBipRemoteNotification", object: nil, userInfo: userInfo)
 
        if let device = connectedBLEDevice {
            device.led?.setLEDColorAsync(UIColor.redColor(), withIntensity: 1)
            device.hapticBuzzer?.startHapticWithDutyCycleAsync(248, pulseWidth: 250, completion: {
                print("Over")
                device.led?.setLEDOnAsync(false, withOptions: 1)
                
                Utilities.setTimeoutNoRepeat(0.2, block: {
                    device.led?.setLEDColorAsync(UIColor.redColor(), withIntensity: 1)
                    device.hapticBuzzer?.startHapticWithDutyCycleAsync(248, pulseWidth: 250, completion: {
                        device.led?.setLEDOnAsync(false, withOptions: 1)
                        
                        Utilities.setTimeoutNoRepeat(0.5, block: {
                            device.led?.setLEDColorAsync(UIColor.redColor(), withIntensity: 1)
                            device.hapticBuzzer?.startHapticWithDutyCycleAsync(248, pulseWidth: 250, completion: {
                                device.led?.setLEDOnAsync(false, withOptions: 1)
                                
                                Utilities.setTimeoutNoRepeat(0.2, block: {
                                    device.led?.setLEDColorAsync(UIColor.redColor(), withIntensity: 1)
                                    
                                    device.hapticBuzzer?.startHapticWithDutyCycleAsync(248, pulseWidth: 250, completion: {
                                        device.led?.setLEDOnAsync(false, withOptions: 1)
                                        print("Vibration is over")
                                    })
                                })
                            })
                        })
                    })
                 })
            })
        }
    }
}

