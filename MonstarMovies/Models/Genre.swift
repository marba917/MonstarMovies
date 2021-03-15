//
//  Genre.swift
//  MonstarMovies
//
//  Created by Mario Jaramillo on 3/15/21.
//

import SwiftyJSON

struct Genre {

    var id = 0
    var name = ""
}

extension Genre {
    
    init(withJSON json: JSON) {
        
        id = json["id"].intValue
        name = json["name"].stringValue
    }
}
