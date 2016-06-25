//
//  APILoginSignup.swift
//  LoveBip
//
//  Created by Marco Montalto on 15/06/16.
//  Copyright © 2016 Marco Montalto. All rights reserved.
//

class APILoginSignup {
    
    static func loginWithFacebook(authentication: String, queryParameters : [String: String]?, completion: (error : NSError?) -> Void) {
        
        APIHandler.sendRequest(.POST, endpoint: "v1.0/login/loginWithFacebook", authentication: authentication, queryParameters: queryParameters)
        {(json, statusCode, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if let _ = error {
                    print("Error with login")
                } else {
                    print("Success registering user with facebook")
                }
                
                completion(error: error)
            })
        }
        
    }

    static func registerForNotifications(authentication: String, deviceToken: String, completion: (error : NSError?) -> Void) {
    
        let params = ["iosDeviceId": deviceToken]
    
        APIHandler.sendRequest(.POST, endpoint: "v1.0/notifications/registerAPNS", authentication: authentication, queryParameters: params)
            {(json, statusCode, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(error: error)
            
                if let _ = error {
                    print("Failed to register for notifications.")
                } else {
                    print("OK")
                }
            })
        }
    }
    
    static func registerPair(authentication: String, emailPair: String, completion: (error : NSError?) -> Void) {
        
        let params = ["emailPair": emailPair]
        
        APIHandler.sendRequest(.POST, endpoint: "v1.0/pair/registerPair", authentication: authentication, queryParameters: params) { (json, statusCode, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completion(error: error)
                
                if let _ = error {
                    print("Failed to register your pair. Error: \(error)")
                } else {
                    if let _ = json {
                        print("Paired with : " + (json!["userPairName"]!! as! String))
                        NSUserDefaults.standardUserDefaults().setObject(json!["userPairName"]!!, forKey: "userPairName")
                        
                        
                    }
                }
            })
        }
        
    }
}