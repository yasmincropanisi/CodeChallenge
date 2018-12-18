//
//  ViewController.swift
//  CodeChallenge
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 16/12/2018.
//  Copyright © 2018 Yasmin Nogueira. All rights reserved.
//

import UIKit

class UpcomingMoviesViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var movieService: MovieService = MovieService()
    var selectedMovie: Movie?
    var shouldShowSearchResults: Bool = false {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        activityIndicator.startAnimating()
        movieService.getGenres { [weak self] (genres, _ ) in
            self?.activityIndicator.stopAnimating()
            guard let genres = genres else {                 self?.displayErrorAlert()
                return }
            MovieService.genres = genres
            self?.fetchMovies(nextPage: false)
        }
    }
    
    func fetchMovies(nextPage: Bool) {
        activityIndicator.startAnimating()
        movieService.fetchUpcomingMovies(nextPage: nextPage) { [weak self] (movies, _) in
            self?.activityIndicator.stopAnimating()
            guard movies != nil else {
                self?.displayErrorAlert()
                return
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func fetchMoviesWith(query: String) {
        activityIndicator.startAnimating()
        movieService.queryMovies(query: query) { [weak self] (movies, _ ) in
            self?.activityIndicator.stopAnimating()
            guard let movies = movies else { return }
            if movies.count == 0 {
                self?.shouldShowSearchResults = true
            }
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailViewController {
            destination.movie = selectedMovie
        }
    }
    
    func moviesToShow() -> [Movie]? {
        if shouldShowSearchResults {
            return movieService.filteredUpcomingMovies
        } else {
            return movieService.upcomingMovies
        }
    }
    
    func displayErrorAlert() {
        let alert = UIAlertController(title: "Something went wrong",
                message: "Please, try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

extension UpcomingMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesToShow()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movies = moviesToShow(),
            let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingMovies")
                as? UpcomingMoviesTableViewCell
            else { return UITableViewCell() }
        let movie = movies[indexPath.row]
        let genres = MovieService.genreDescriptionsFor(ids: movie.genres)
        cell.configureCellFor(movieName: movie.title,
                              movieReleaseDate: movie.releaseDate,
                              moviePosterURL: movie.releaseDate, genres: genres)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let movies = moviesToShow() else { return }
        if indexPath.row >= movies.count - 3 && !shouldShowSearchResults {
            fetchMovies(nextPage: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movies = moviesToShow() else { return }
        selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "movieDetail", sender: self)        
    }
    
}

extension UpcomingMoviesViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        movieService.filteredUpcomingMovies?.removeAll()
        searchBar.text = ""
        searchBar.showsCancelButton = false
        shouldShowSearchResults = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(self.queryMovies(_:)), object: searchBar)
        
        perform(#selector(self.queryMovies(_:)), with: searchBar, afterDelay: 0.86)
    }
    
    @objc func queryMovies(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            movieService.filteredUpcomingMovies?.removeAll()
            shouldShowSearchResults = false
            return
        }
        activityIndicator.startAnimating()
        shouldShowSearchResults = true
        self.fetchMoviesWith(query: query)
    }
}
