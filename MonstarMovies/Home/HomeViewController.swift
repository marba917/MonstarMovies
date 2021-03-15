//
//  HomeViewController.swift
//  MonstarMovies
//
//  Created by Mario Jaramillo on 3/13/21.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLb: UILabel!
    @IBOutlet weak var searchViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoritesButton: UIButton!
    
    private let rxBag = DisposeBag()
    private let movies: BehaviorRelay<[Movie]> = BehaviorRelay(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moviesCollectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        messageLb.text = "Search for movies using the button above..."
        
        //Set initial width to animate it later when button tapped
        searchViewWidthConstraint.constant = 40
        
        //Set a timer to randomly change button color
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(changeFavoritesButtonColor), userInfo: nil, repeats: true)
        
        subscribeRxElements()
    }
}


//MARK: - IBActions

extension HomeViewController {
    
    @IBAction func searchButtonCTA(_ sender: Any) {
        
        //Set the view width to use the entire view width (margin = 24)
        searchViewWidthConstraint.constant = view.frame.width - 104
        searchTf.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.4) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func favoritesButtonCTA(_ sender: Any) {
        
        //create the vc and present it modally
        let vc = getVC(from: "Main", withId: "FavoritesViewController") as! FavoritesViewController
        present(vc, animated: true, completion: nil)
    }
}


//MARK: - Functions

extension HomeViewController {
    
    private func subscribeRxElements() {
        
        //Textfield search button pressed event
        searchTf.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] () in
                
                guard let self = self, let query = self.searchTf.text else { return }
                guard !query.isEmpty else {
                    
                    self.showAlertDefault(title: nil, message: "Please enter a valid movie name")
                    return
                }
                
                self.searchMovies(query: query)
                
            }).disposed(by: rxBag)
        
        //Bind CV contents to the movies array
        movies.bind(to: moviesCollectionView.rx.items(cellIdentifier: "MovieCell")) { row, model, cell in
            
            guard let cell = cell as? MovieCell else { return }
            cell.setMovieInfo(movie: model)
                        
        }.disposed(by: rxBag)
        
        //CollectionView didSelect item
        moviesCollectionView.rx.modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] (movie) in
                
                guard let self = self else { return }
                print("Selected movie: \(movie.id)")
                let vc = self.getVC(from: "Main", withId: "MovieViewController") as! MovieViewController
                vc.movieId = movie.id
                vc.setModalPresentation()
                self.present(vc, animated: true, completion: nil)
                
            }).disposed(by: rxBag)
        
    }
    
    private func searchMovies(query: String) {
        
        LoadingIndicatorView.show()
        self.movies.accept([])
        
        Api.searchMovies(query: query) { [weak self] (response, movies) in
            
            guard let self = self else { return }
            
            //Delay to show the search animation (you can remove it later)
            self.delay(3.0) {
                LoadingIndicatorView.hide()
            }
            
            if response == .success {
                
                if !movies.isEmpty {
                    
                    self.configureCollectionViewLayout(itemsCount: movies.count)
                    self.movies.accept(movies)
                    self.messageView.alpha = 0
                    self.moviesCollectionView.alpha = 1
                    
                } else {
                    
                    self.messageView.alpha = 1
                    self.moviesCollectionView.alpha = 0
                    self.messageLb.text = "No movies found..."
                }
                
            } else {
                
                self.showAlertDefault(title: "Network Error", message: "We are having connection problems. Please try again later")
            }
        }
    }
    
    private func configureCollectionViewLayout(itemsCount: Int) {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        //if movie count is more than 1, set the width a little shorter to let the user know there are more items
        let size = itemsCount < 2 ? view.frame.size.width : view.frame.size.width - 40
        flowLayout.itemSize = CGSize(width: size, height: moviesCollectionView.frame.height)
        flowLayout.scrollDirection = .horizontal
        moviesCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    @objc private func changeFavoritesButtonColor() {
        
        favoritesButton.tintColor = .random()
    }
}
