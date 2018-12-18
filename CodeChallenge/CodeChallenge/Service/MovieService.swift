//
//  MovieService.swift
//  CodeChallenge
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 16/12/2018.
//  Copyright © 2018 Yasmin Nogueira. All rights reserved.
//

import Foundation

class MovieService {
    
    private var serviceRequest = ServiceRequest()
    var upcomingMovies: [Movie]?
    var filteredUpcomingMovies: [Movie]?
    static var genres: [Genre]?
    static var imageURL: String = "https://image.tmdb.org/t/p/w500"
    var totalPages: Int = 0
    var page: Int = 0
    
    func fetchUpcomingMovies(nextPage: Bool, completion: @escaping (_ movies: [Movie]?, _ error: Error?) -> Void) {
        
        guard page <= totalPages else {
            completion(nil, nil)
            return
        }
        page = nextPage ? page + 1 : 1
        serviceRequest.perform(request: .movieAPI(.upcomingMovies(page: page))) { [weak self](json, error) in
            guard error == nil else { completion(nil, error)
                return
            }
            guard let json = json, let movies = try? self?.transformToObject(from: json, type: MovieResults.self) else {
                completion(nil, nil)
                return
            }
            self?.setupTotalPages(total: movies?.totalPages)
            self?.updateMovies(movies: movies?.results, nextPage: nextPage)
            
            completion(movies?.results, nil)
        }
    }
    
    func queryMovies(query: String, completion: @escaping (_ movies: [Movie]?, _ error: Error?) -> Void) {
        
        serviceRequest.perform(request: .movieAPI(.queryMovie(query: query))) { [weak self](json, error) in
            guard error == nil else { completion(nil, error)
                return
            }
            guard let json = json, let movies = try? self?.transformToObject(from: json, type: MovieResults.self) else {
                completion(nil, nil)
                return
            }
            self?.filteredUpcomingMovies = movies?.results
            completion(movies?.results, nil)
        }
    }
    
    func setupTotalPages(total: Int?) {
        guard totalPages == 0, let total = total else { return }
        totalPages = total
    }
    
    func updateMovies(movies: [Movie]?, nextPage: Bool) {
        guard let movies = movies else { return }
        if nextPage {
            self.upcomingMovies?.append(contentsOf: movies)
        } else {
            self.upcomingMovies = movies
        }
    }
    
    func getGenres(completion: @escaping (_ genres: [Genre]?, _ error: Error?) -> Void) {
        serviceRequest.perform(request: .movieAPI(.genres)) { [weak self] (json, error) in
            guard error == nil else { completion(nil, error)
                return
            }
            guard let json = json, let genres =
                try? self?.transformToObject(from: json, type: Genres.self)
                else { completion(nil, nil)
                        return
                }
            completion(genres?.genres, nil)
        }
    }
    
    static func genreDescriptionsFor(ids: [Int]) -> String {
        
        var descriptions = ""
        
        guard let descriptionsForIds = MovieService.genres?.filter({ (genre) -> Bool in
            return ids.contains(where: { (id) -> Bool in
                return id == genre.id
            })
        }) else { return descriptions }
        
        descriptions = descriptionsForIds.map({ (genre) -> String in
            return genre.name
        }).joined(separator: ", ")
        
        return descriptions
    }
    func transformToObject<T: Decodable>(from jsonString: String, type: T.Type) throws -> T {
        let jsonData = Data(jsonString.utf8)
        return try JSONDecoder().decode(T.self, from: jsonData)
    }
}
