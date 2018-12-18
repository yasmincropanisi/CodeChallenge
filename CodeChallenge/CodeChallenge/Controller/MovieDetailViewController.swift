//
//  MovieDetailViewController.swift
//  CodeChallenge
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 18/12/2018.
//  Copyright © 2018 Yasmin Nogueira. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMovieDetails()
    }
    
    // MARK: - View configuration
    
    func configureMovieDetails() {
        guard let movie = movie else { return }
        self.navigationItem.title = movie.title
        nameLabel.text = movie.title
        overviewLabel.text = movie.overview
        releaseDate.text = movie.releaseDate
        let genres = MovieService.genreDescriptionsFor(ids: movie.genres)
        genreLabel.text = genres
        setupImage(movie: movie)
    }
    
    func setupImage(movie: Movie) {
        guard let posterURL = movie.posterURL,
            let url = URL(string: "\(MovieService.imageURL)\(posterURL)")
            else { return }
        let resource = ImageResource(downloadURL: url, cacheKey: movie.title )
        let placeholder = UIImage(named: "placeholder")
        movieImageView.kf.setImage(with: resource, placeholder: placeholder, options: [.transition(.fade(0.3))])
    }
    
}
