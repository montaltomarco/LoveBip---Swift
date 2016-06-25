//
//  APIEmotions.swift
//  LoveBip
//
//  Created by Marco Montalto on 24/06/16.
//  Copyright © 2016 Marco Montalto. All rights reserved.
//

class APIEmotions {
    
    static func sendEmotions(authentication: String, completion: (error : NSError?) -> Void) {
        APIHandler.sendRequest(.POST, endpoint: "v1.0/api/sendemotion", authentication: authentication, queryParameters: [:])
        {(json, statusCode, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if let _ = error {
                    print("Error while sending emotion")
                } else {
                    print("Emotion sent <3")
                }
                
                completion(error: error)
            })
        }
    }
}