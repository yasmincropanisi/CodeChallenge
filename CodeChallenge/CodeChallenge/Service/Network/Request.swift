//
//  Request.swift
//  CodeChallenge
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 16/12/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation

enum Request {
    
    case movieAPI(MovieAPI)
    
    enum MovieAPI {
        case upcomingMovies()
    }
}
