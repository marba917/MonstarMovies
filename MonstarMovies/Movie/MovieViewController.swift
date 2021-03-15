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
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteStar: UIImageView!
    @IBOutlet weak var starHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var starWidthConstraint: NSLayoutConstraint!
    
    var movieId: Int?
    var isFavorite = false
    var movie: Movie?
    var delegate: MovieDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let movieId = movieId else {
            
            dismiss(animated: true, completion: nil)
            return
        }
        
        getMovie(id: movieId)
        checkFavorite()
    }
    

    // MARK: - Actions
    
    @IBAction func closeButtonCTA(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func favoriteButtonCTA(_ sender: Any) {
        
        guard let movie = movie else { return }
        
        if isFavorite {
            
            DBManager.deleteMovie(movieId: movie.id)
            favoriteButton.tintColor = .lightGray
            isFavorite = false
            
        } else {
            
            DBManager.addMovie(movie: movie)
            favoriteButton.tintColor = .systemYellow
            isFavorite = true
            animateStar()
        }
        
        delegate?.didUpdateFavoriteStatus()
    }
    
    
    // MARK: - Functions

    //Retrieves movie info from the endpoint
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
    
    //sets the movie info in the UI
    private func setMovieInfo(movie: Movie) {
        
        self.movie = movie
        let url = URL(string: movie.image)
        coverimage.kf.setImage(with: url)
        nameLb.text = movie.title
        scoreLb.text = String(movie.vote_average)
        yearLb.text = String(movie.release_date.year)
        overviewTv.text = movie.overview
        hashTagsLb.text = movie.genres.reduce("") {text, name in "\(text ?? "") #\(name.name)"}
    }
    
    //Checks if the movie is already in my favorites list
    private func checkFavorite() {
        
        let favorites = DBManager.getFavoriteMovies()
        favorites.forEach { (movie) in
            
            if movieId == movie.id {
                
                favoriteButton.tintColor = .systemYellow
                isFavorite = true
                return
            }
        }
    }
    
    //star animation when the user sets the movie as favorite
    private func animateStar() {
        
        starWidthConstraint.constant = 240
        starHeightConstraint.constant = 240
        
        UIView.animate(withDuration: 0.8) {
            
            self.favoriteStar.alpha = 1
            self.view.layoutIfNeeded()
            
        } completion: { (completion) in
            
            self.starWidthConstraint.constant = 0
            self.starHeightConstraint.constant = 0
            self.favoriteStar.alpha = 0
        }

    }
}




//MARK: - Delegate

protocol MovieDelegate {
    
    func didUpdateFavoriteStatus()
}
