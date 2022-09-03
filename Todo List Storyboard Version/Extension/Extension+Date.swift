//
//  Extension+Date.swift
//  Todo List Storyboard Version
//
//  Created by TheGIZzz on 3/9/2565 BE.
//

import Foundation

extension Date {
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: self)
        
    }
}
