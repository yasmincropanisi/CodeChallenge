//
//  HTTPRequestProtocol.swift
//  CodeChallenge
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 16/12/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation
import Alamofire

protocol HttpRequest {
    
    var url: String { get }
    var path: String { get }
    var body: [String: Any] {get}
    var headers: [String: String] {get}
    var parameters: Parameters { get }
    var method: HTTPMethod { get }
}
