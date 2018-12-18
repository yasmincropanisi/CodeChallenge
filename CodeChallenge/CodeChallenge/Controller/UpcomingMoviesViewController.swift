//
//  ViewController.swift
//  CodeChallenge
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 16/12/2018.
//  Copyright © 2018 Yasmin Nogueira. All rights reserved.
//

import UIKit

class UpcomingMoviesViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var movieService: MovieService = MovieService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        movieService.getGenres { [weak self] (genres, error) in
            guard let genres = genres else { return }
            MovieService.genres = genres
            self?.fetchMovies(nextPage: false)
        }
    }
    
    func fetchMovies(nextPage: Bool) {
        movieService.fetchUpcomingMovies(nextPage: nextPage) { [weak self] (movies, error) in
            guard let movies = movies else { return }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
    }


}

extension UpcomingMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieService.upcomingMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movies = movieService.upcomingMovies, let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingMovies") as? UpcomingMoviesTableViewCell else { return UITableViewCell() }
            let movie = movies[indexPath.row]
            let genres = movieService.genreDescriptionsFor(ids: movie.genres)
            cell.configureCellFor(movie: movie, genres: genres)
            return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let movies = movieService.upcomingMovies else { return }
        if indexPath.row >= movies.count - 3 {
            fetchMovies(nextPage: true)
        }
    }
    
    
}
