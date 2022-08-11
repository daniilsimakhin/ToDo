//
//  ToDoItem.swift
//  ToDo
//
//  Created by Даниил Симахин on 11.08.2022.
//

import Foundation

enum Importance {
    case important
    case unimportant
    case ordinary
}

struct ToDoItem {
    let id: String = UUID().uuidString
    let text: String
    let importance: Importance = .ordinary
    let deadline: Date?
    let isComplete: Bool = false
    let dateCreated: Date
    let dateChanged: Date?
}
