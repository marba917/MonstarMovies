//
//  Movie.swift
//  MonstarMovies
//
//  Created by Mario Jaramillo on 3/13/21.
//

import SwiftyJSON

struct Movie {

    var id = 0
    var title = ""
    var poster = ""
    var image = ""
    var vote_average = 0.0
    var release_date = Date()
    var overview = ""
    var genres = [Genre]()
}

extension Movie {
    
    init(withJSON json: JSON) {
        
        id = json["id"].intValue
        title = json["title"].stringValue
        poster = "\(Configs.postersUrl)\(json["poster_path"].stringValue)"
        image = "\(Configs.postersUrl)\(json["backdrop_path"].stringValue)"
        vote_average = json["vote_average"].doubleValue
        release_date = json["release_date"].stringValue.toDate
        overview = json["overview"].stringValue
        genres = json["genres"].arrayValue.map{Genre(withJSON: $0)}
    }
}


