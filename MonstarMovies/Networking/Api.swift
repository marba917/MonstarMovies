//
//  Api.swift
//  MonstarMovies
//
//  Created by Mario Jaramillo on 3/13/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class Api {
    
    struct Endpoints {
        
        static let HOST = "https://api.themoviedb.org"
        static let movies = "\(HOST)/3/search/movie?api_key=\(Configs.theMovieDBApiKey)&query="
        static let movie = "\(HOST)/3/movie"
    }
    
    enum ResponseType {
        
        case success
        case error
    }
    
    
    
    //MARK: - Movies
    
    //calls the search endpoint with the query parameter. Returns an array of movies or empty array
    static func searchMovies(query: String, completionBlock: @escaping (ResponseType,[Movie]) -> Void) {
        
        let text = query.replacingOccurrences(of: " ", with: "+")
        let url = "\(Endpoints.movies)/\(text)"
        var movies = [Movie]()
        
        print("searching for movies...\(url)")

        AF.request(url, method: .get, parameters: nil)
            .responseJSON { response in
                
                if let data = response.value {
                    
                    let json = JSON(data)
                    
                    //create an array of Movie objects
                    json["results"].arrayValue.forEach({ (movieJson) in
                        movies.append(Movie(withJSON: movieJson))
                    })
                    completionBlock(.success,movies)
                    
                } else {
                    
                    completionBlock(.error,[])
                }
        }
    }
    
    //obtains movie details from the endpoint. returns the movie object
    static func getMovieInfo(id: Int, completionBlock: @escaping (ResponseType,Movie) -> Void) {
        
        let url = "\(Endpoints.movie)/\(id)?api_key=\(Configs.theMovieDBApiKey)"
        
        print("Getting movie info...\(url)")

        AF.request(url, method: .get, parameters: nil)
            .responseJSON { response in
                
                if let data = response.value {
                    
                    let json = JSON(data)
                    let movie = Movie(withJSON: json)
                    completionBlock(.success,movie)
                    
                } else {
                    
                    completionBlock(.error,Movie())
                }
        }
    }
    
}
