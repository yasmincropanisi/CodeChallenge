//
//  Movie.swift
//  CodeChallenge
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 16/12/2018.
//  Copyright © 2018 Yasmin Nogueira. All rights reserved.
//

import Foundation

struct MovieResults : Decodable {
    let total_pages: Int
    let total_results: Int
    let page: Int
    let results: [Movie]
}


struct Movie: Decodable {
    
    let id: Int
    let title: String
    let posterURL: String?
    var releaseDate: String
    var genres: [Int]
    var voteAverage: Double
    var overview: String
    
    private enum CodingKeys: String, CodingKey {
        case id,
            title,
            posterURL = "poster_path",
            genres = "genre_ids",
            releaseDate = "release_date",
            voteAverage = "vote_average",
            overview
    }
    
}
