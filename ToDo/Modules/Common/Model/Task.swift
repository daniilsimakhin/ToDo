//
//  Task.swift
//  ToDo
//
//  Created by Даниил Симахин on 11.08.2022.
//

import Foundation

enum Importance: String, Codable, CaseIterable {
    case unimportant
    case ordinary
    case important
}

struct Task: Codable, Equatable {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    var isComplete: Bool
    let dateCreated: Date
    let dateChanged: Date?
    
    init(id: String, text: String, importance: Importance, deadline: Date?, isComplete: Bool, dateCreated: Date, dateChanged: Date?) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isComplete = isComplete
        self.dateCreated = dateCreated
        self.dateChanged = dateChanged
    }
}
