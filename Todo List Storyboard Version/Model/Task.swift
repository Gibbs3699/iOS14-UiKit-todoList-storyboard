//
//  Task.swift
//  Todo List Storyboard Version
//
//  Created by TheGIZzz on 31/8/2565 BE.
//

import Foundation
import FirebaseFirestoreSwift

struct Task: Identifiable, Codable {
    
    @DocumentID var id: String?
    @ServerTimestamp var createdAt: Date?
    let title: String
    var isDone: Bool = false
    var doneAt: Date?
    var deadLine: Date?
    
}
