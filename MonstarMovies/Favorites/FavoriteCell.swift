//
//  FavoriteCell.swift
//  MonstarMovies
//
//  Created by Mario Jaramillo on 3/15/21.
//

import UIKit
import Kingfisher

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var scoreLb: UILabel!
    @IBOutlet weak var yearLb: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    func setMovieInfo(movie: Movie) {
        
        let url = URL(string: movie.image)
        movieImage.kf.setImage(with: url)
        nameLb.text = movie.title
        scoreLb.text = String(movie.vote_average)
        yearLb.text = String(movie.release_date.year)
    }
}
