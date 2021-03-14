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
}

extension Movie {
    
    init(withJSON json: JSON) {
        
        id = json["id"].stringValue
        title = json["title"].stringValue
        poster = "\(Configs.postersUrl)\(json["poster_path"].stringValue)"
    }
}


