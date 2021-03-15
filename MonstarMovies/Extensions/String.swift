//
//  String.swift
//  MonstarMovies
//
//  Created by Mario Jaramillo on 3/13/21.
//

import Foundation

extension String {
    
    //Convert a String to a Date
    var toDate: Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "America/Bogota")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let convertedDate = dateFormatter.date(from: self) else {
            return Date()
        }
        
        return convertedDate
    }
}
