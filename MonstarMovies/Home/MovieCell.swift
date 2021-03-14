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
    
    func setMovieInfo(movie: Movie) {
        
        let url = URL(string: movie.poster)
        posterImage.kf.setImage(with: url)
    }
}
