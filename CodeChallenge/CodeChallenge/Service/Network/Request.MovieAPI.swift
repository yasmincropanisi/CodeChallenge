//
//  Request.MovieAPI.swift
//  CodeChallenge
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 16/12/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension Request.MovieAPI: HttpRequest {
    
    var response: Codable? {
        return nil
    }
    
    var url: String {

        switch self {
        case .upcomingMovies, .genres:
            return "https://api.themoviedb.org/3/"
        }
    }
    
    var path: String {
        switch self {
        case .upcomingMovies:
            return "movie/upcoming"
        case .genres:
            return "genre/movie/list"
        }
    }
    
    var body: [String : Any] {
        let body = [String : Any]()
        switch self {
        case .upcomingMovies(let page):
            return ["api_key": ServiceRequest.apiKey, "page": page]
        case .genres:
            return ["api_key": ServiceRequest.apiKey]
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .upcomingMovies, .genres:
            return ["Content-Type": "application/json"]
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .upcomingMovies(let page):
            return ["api_key": ServiceRequest.apiKey, "page": page]
        case .genres:
            return ["api_key": ServiceRequest.apiKey]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .upcomingMovies, .genres:
            return .get
        }
    }
}
