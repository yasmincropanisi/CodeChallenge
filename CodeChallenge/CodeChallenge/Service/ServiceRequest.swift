//
//  ServiceRequest.swift
//  CodeChallenge
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 16/12/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class ServiceRequest {
    
    static let apiKey = "4b5a25b48b6326f0ba4056890e569325"

    func perform(request: Request, _ completion: @escaping (_ response: String?, _ error: Error?) -> Void) {
        let parameters = request.body
        Alamofire.request("\(request.url)\(request.path)", method: request.method, parameters: parameters, encoding: URLEncoding.default, headers: request.headers)
            .responseJSON { response in
                guard response.result.isSuccess, let value = response.result.value else {
                    completion(nil, response.result.error)
                    return
                }
                let data = value as! [String : AnyObject]
                let string = self.convertToJSONString(value: data as AnyObject)
                completion(string, nil)
        }
    }
    
    func convertToJSONString(value: AnyObject) -> String? {
        if JSONSerialization.isValidJSONObject(value) {
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: [])
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch{
            }
        }
        return nil
    }
}
