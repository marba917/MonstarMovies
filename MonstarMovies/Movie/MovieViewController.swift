//
//  MovieViewController.swift
//  MonstarMovies
//
//  Created by Mario Jaramillo on 3/15/21.
//

import UIKit

class MovieViewController: UIViewController {
    
    @IBOutlet weak var coverimage: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var scoreLb: UILabel!
    @IBOutlet weak var yearLb: UILabel!
    @IBOutlet weak var overviewTv: UITextView!
    @IBOutlet weak var hashTagsLb: UILabel!
    
    var movieId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let movieId = movieId else {
            
            dismiss(animated: true, completion: nil)
            return
        }
        
        getMovie(id: movieId)
    }
    

    // MARK: - Actions
    
    @IBAction func closeButtonCTA(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions

    private func getMovie(id: Int) {
        
        Api.getMovieInfo(id: id) { [weak self] (response, movie) in
            
            guard let self = self else { return }
            
            if response == .success {
                
                self.setMovieInfo(movie: movie)
                
            } else {
                
                self.showAlertDefault(title: "Network Error", message: "We couldn't get the movie info. Please try again later")
            }
        }
    }
    
    private func setMovieInfo(movie: Movie) {
        
        let url = URL(string: movie.image)
        coverimage.kf.setImage(with: url)
        nameLb.text = movie.title
        scoreLb.text = String(movie.vote_average)
        yearLb.text = String(movie.release_date.year)
        overviewTv.text = movie.overview
        hashTagsLb.text = movie.genres.reduce("") {text, name in "\(text ?? "") #\(name.name)"}
    }
}
