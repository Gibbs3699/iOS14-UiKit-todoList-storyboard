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
    
    func toRelativeString() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let today = Date()
        return formatter.localizedString(for: self, relativeTo: today)
    }
    
    func isOverDue() -> Bool {
        let today = Date()
        return self < today
    }
}
