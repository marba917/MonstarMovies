//
//  FavoritesViewController.swift
//  MonstarMovies
//
//  Created by Mario Jaramillo on 3/15/21.
//

import UIKit
import RxCocoa
import RxSwift

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var moviesTv: UITableView!
    @IBOutlet weak var noFavoritesLb: UILabel!
    
    private let rxBag = DisposeBag()
    private let movies: BehaviorRelay<[Movie]> = BehaviorRelay(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //register the cell nib so it can be used in the table
        moviesTv.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "FavoriteCell")
        
        noFavoritesLb.alpha = 0
        subscribeRxElements()
        getMovies()
    }
    

    // MARK: - Actions

    @IBAction func closeButtonCTA(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    private func subscribeRxElements() {
        
        //Bind CV contents to the movies array
        movies.bind(to: moviesTv.rx.items(cellIdentifier: "FavoriteCell")) { row, model, cell in
            
            self.moviesTv.rowHeight = 100
            guard let cell = cell as? FavoriteCell else { return }
            cell.setMovieInfo(movie: model)
            cell.selectionStyle = .none
                        
        }.disposed(by: rxBag)
        
        //CollectionView didSelect item
        moviesTv.rx.modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] (movie) in
                
                guard let self = self else { return }
                print("Selected movie: \(movie.id)")
                let vc = self.getVC(from: "Main", withId: "MovieViewController") as! MovieViewController
                vc.movieId = movie.id
                vc.setModalPresentation()
                vc.delegate = self
                self.present(vc, animated: true, completion: nil)
                
            }).disposed(by: rxBag)
        
        //Swipe to delete
        moviesTv.rx.itemDeleted
            .subscribe {
                guard let row = $0.element?.row else { return }
                let movie = self.movies.value[row]
                print("delete movie : \(movie.title)")
                DBManager.deleteMovie(movieId: movie.id)
                self.getMovies()
            }
            .disposed(by: rxBag)
        
    }
    
    private func getMovies() {
        
        let movies = DBManager.getFavoriteMovies()
        self.movies.accept(movies)
        noFavoritesLb.alpha = movies.isEmpty ? 1 : 0
    }
}



//MARK: - Movie delegate

extension FavoritesViewController: MovieDelegate {
    
    func didUpdateFavoriteStatus() {
        
        getMovies()
    }
}
