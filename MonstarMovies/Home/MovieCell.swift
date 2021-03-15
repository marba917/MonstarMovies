//
//  MovieCell.swift
//  MonstarMovies
//
//  Created by Mario Jaramillo on 3/14/21.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var scoreLb: UILabel!
    @IBOutlet weak var yearLb: UILabel!
    
    func setMovieInfo(movie: Movie) {
        
        let url = URL(string: movie.poster)
        posterImage.kf.setImage(with: url)
        nameLb.text = movie.title
        scoreLb.text = String(movie.vote_average)
        yearLb.text = String(movie.release_date.year)
    }
}
