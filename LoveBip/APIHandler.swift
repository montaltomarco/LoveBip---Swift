//
//  APIHandler.swift
//  LoveBip
//
//  Created by Marco Montalto on 15/06/16.
//  Copyright © 2016 Marco Montalto. All rights reserved.
//

import Alamofire

class APIHandler {
    
    static let baseUrl = "http://93.186.254.61/"
    
    static func sendRequest(method: Alamofire.Method, endpoint: String, authentication: String!, queryParameters : [String: String]?,
                            completion: (json: AnyObject?, statusCode:Int?, error : NSError?) -> Void ) {
        
        let stringURL = APIHandler.baseUrl+endpoint
        
        let headers = [
            "email": "" + authentication
        ]
        
        Alamofire.request(method, stringURL, parameters: queryParameters, encoding: .JSON, headers: headers)
            .validate().responseJSON { response in
                
            switch response.result {
                case .Success:
                    
                    print("\n ----Response from server is successful")
                    
                    if let JSON = response.result.value {
                        completion(json: JSON, statusCode: response.response?.statusCode, error: nil)
                    } else {
                        completion(json: ["data":"nodata"], statusCode: response.response?.statusCode, error: nil)
                    }
                
                case .Failure(let error):
                    print("\n ----Error from server. Cannot validate the request")
                    print(error)
                    completion(json: ["data":"nodata"], statusCode: error.code, error: error)
                }
        }
    }
}
