//
//  Request+HttpRequest.swift
//  CodeChallenge
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 16/12/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension Request: HttpRequest {
    
    var response: Codable? {
        return String()
    }
    
    var url: String {
        switch self {
        case .movieAPI(let request):
            return request.url
        }
    }
    
    var path: String {
        switch self {
        case .movieAPI(let request):
            return request.path
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .movieAPI(let request):
            return request.headers
        }
    }
    
    var body: [String: Any] {
        switch self {
        case .movieAPI(let request):
            return request.body
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .movieAPI(let request):
            return request.parameters
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .movieAPI(let request):
            return request.method
        }
    }
}
