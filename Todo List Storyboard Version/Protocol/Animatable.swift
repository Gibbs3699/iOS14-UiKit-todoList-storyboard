//
//  Animatable.swift
//  Todo List Storyboard Version
//
//  Created by TheGIZzz on 2/9/2565 BE.
//

import Foundation
import Loaf

protocol Animatable {
    
}

extension Animatable where Self: UIViewController { // only UIViewController can conform this protocol
    
    
    func showToast(state: Loaf.State, message: String, location: Loaf.Location = .top, duration: TimeInterval = 1.0) {
        DispatchQueue.main.async {
            Loaf(message,
                 state: state,
                 location: location,
                 sender: self).show(.custom(duration))
        }
    }
    
}
