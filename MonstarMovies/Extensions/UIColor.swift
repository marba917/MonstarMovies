//
//  UIColor.swift
//  MonstarMovies
//
//  Created by Mario Jaramillo on 3/13/21.
//

import UIKit

extension UIColor {
    
    static func random() -> UIColor {
            return UIColor(
               red:   CGFloat(arc4random()) / CGFloat(UInt32.max),
               green: CGFloat(arc4random()) / CGFloat(UInt32.max),
               blue:  CGFloat(arc4random()) / CGFloat(UInt32.max),
               alpha: 1.0
            )
        }
}
