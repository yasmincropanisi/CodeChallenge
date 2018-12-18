//
//  Genres.swift
//  CodeChallenge
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 17/12/2018.
//  Copyright © 2018 Yasmin Nogueira. All rights reserved.
//

import Foundation

struct Genres: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
