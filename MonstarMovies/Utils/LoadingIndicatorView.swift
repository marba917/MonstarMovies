//
//  LoadingIndicatorView.swift
//  MonstarMovies
//
//  Created by Mario Jaramillo on 3/13/21.
//

import UIKit
import Lottie

class LoadingIndicatorView {
    
    static var currentOverlay : UIView?
    
    static func show() {
        guard let currentMainWindow = UIApplication.shared.keyWindow else {
            return
        }
        show(currentMainWindow)
    }
    
    static func show(_ loadingText: String) {
        guard let currentMainWindow = UIApplication.shared.keyWindow else {
            return
        }
        show(currentMainWindow, loadingText: loadingText)
    }
    
    static func show(_ overlayTarget : UIView) {
        show(overlayTarget, loadingText: nil)
    }
    
    static func show(_ overlayTarget : UIView, loadingText: String?) {
        // Clear it first in case it was already shown
        hide()
        
        // Create the overlay
        let overlay = UIView(frame: overlayTarget.frame)
        overlay.center = overlayTarget.center
        overlay.alpha = 0
        overlay.backgroundColor = .black
        overlayTarget.addSubview(overlay)
        overlayTarget.bringSubviewToFront(overlay)
        
        let loadingAnimationView = AnimationView()
        loadingAnimationView.frame.size = CGSize(width: 200, height: 120)
        loadingAnimationView.animation = Animation.named("loading")
        loadingAnimationView.contentMode = .scaleAspectFit
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.play()
        loadingAnimationView.center = overlay.center
        overlay.addSubview(loadingAnimationView)
       
        let label = UILabel(frame: CGRect(x: 25, y: overlay.center.y, width: overlay.frame.width - 50, height: 22))
        label.center = CGPoint(x: overlay.center.x, y: overlay.center.y + 80)
        label.textAlignment = .center
        label.text = "Loading..."
        label.textColor = .white
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        overlay.addSubview(label)
        
        // Create label
        if let textString = loadingText {
            label.text = textString
        }
        
        // Animate the overlay to show
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        overlay.alpha = overlay.alpha > 0 ? 0 : 0.9
        UIView.commitAnimations()
        
        currentOverlay = overlay
    }
    
    static func hide() {
        if currentOverlay != nil {
            currentOverlay?.removeFromSuperview()
            currentOverlay =  nil
        }
    }
}

