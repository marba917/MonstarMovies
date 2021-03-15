//
//  Movie.swift
//  MonstarMovies
//
//  Created by Mario Jaramillo on 3/13/21.
//

import SwiftyJSON

struct Movie {

    var id = ""
    var title = ""
    var poster = ""
    var vote_average = 0.0
    var release_date = Date()
}

extension Movie {
    
    init(withJSON json: JSON) {
        
        id = json["id"].stringValue
        title = json["title"].stringValue
        poster = "\(Configs.postersUrl)\(json["poster_path"].stringValue)"
        vote_average = json["vote_average"].doubleValue
        release_date = json["release_date"].stringValue.toDate
    }
}


