//
//  UpcomingMoviesTableViewCell.swift
//  CodeChallenge
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 17/12/2018.
//  Copyright © 2018 Yasmin Nogueira. All rights reserved.
//

import UIKit
import Kingfisher

class UpcomingMoviesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var genreLabel: UILabel!
    
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCellFor(movieName: String, movieReleaseDate: String, moviePosterURL: String, genres: String) {
        nameLabel.text = movieName
        genreLabel.text = genres
        releaseDateLabel.text = movieReleaseDate
        updateImage(posterURL: moviePosterURL, movieName: movieName)
    }
    
    func updateImage(posterURL: String, movieName: String) {
        guard let url = URL(string: "\(MovieService.imageURL)\(posterURL)") else { return }
        let resource = ImageResource(downloadURL: url, cacheKey: movieName )
        let placeholder = UIImage(named: "placeholder")
        movieImageView.kf.setImage(with: resource, placeholder: placeholder, options: [.transition(.fade(0.3))])
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}

