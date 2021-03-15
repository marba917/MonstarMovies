//
//  Date.swift
//  MonstarMovies
//
//  Created by Mario Jaramillo on 3/13/21.
//

import Foundation

extension Date {
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
}
