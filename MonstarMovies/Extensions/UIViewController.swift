//
//  UIViewController.swift
//  MonstarMovies
//
//  Created by Mario Jaramillo on 3/13/21.
//

import UIKit

extension UIViewController {
    
    func getVC (from: String, withId id: String) -> UIViewController {
        return UIStoryboard(name: from, bundle: nil).instantiateViewController(withIdentifier: id)
    }
    
    func showAlertDefault (title: String?, message: String) {
        
        let alertController = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        alertController.view.tintColor = .blue
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
