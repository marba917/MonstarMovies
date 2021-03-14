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
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    private let rxBag = DisposeBag()
    private let movies: BehaviorRelay<[Movie]> = BehaviorRelay(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moviesCollectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        let flowLayout = UICollectionViewFlowLayout()
        let size = view.frame.size.width
        flowLayout.itemSize = CGSize(width: size, height: moviesCollectionView.frame.height)
        flowLayout.scrollDirection = .horizontal
        moviesCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        
        subscribeRxElements()
    }
    
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
        
        //CV contents
        movies.bind(to: moviesCollectionView.rx.items(cellIdentifier: "MovieCell")) { row, model, cell in
            
            guard let cell = cell as? MovieCell else { return }
            cell.setMovieInfo(movie: model)
                        
        }.disposed(by: rxBag)
        
    }
    
    private func searchMovies(query: String) {
        
        //TODO: Show loading indicator
        
        Api.searchMovies(query: query) { [weak self] (response, movies) in
            
            guard let self = self else { return }
            
            if response == .success {
                
                if !movies.isEmpty {
                    
                    self.movies.accept(movies)
                    self.emptyView.alpha = 0
                    
                } else {
                    
                    self.emptyView.alpha = 1
                }
                
            } else {
                
                self.showAlertDefault(title: "Network Error", message: "We are having connection problems. Please try again later")
            }
        }
    }

}
