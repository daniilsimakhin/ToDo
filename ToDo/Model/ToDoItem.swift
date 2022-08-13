//
//  ToDoItem.swift
//  ToDo
//
//  Created by Даниил Симахин on 11.08.2022.
//

import Foundation

enum Importance: String {
    case important
    case unimportant
    case ordinary
    
    static func convertFromString(string: String) -> Importance {
        if string == Importance.important.rawValue {
            return Importance.important
        } else if string == Importance.unimportant.rawValue {
            return Importance.important
        } else {
            return Importance.important
        }
    }
}

struct ToDoItem {
    let id: String = UUID().uuidString
    let text: String
    let importance: Importance
    let deadline: Date?
    let isComplete: Bool
    let dateCreated: Date
    let dateChanged: Date?
}

extension ToDoItem {
    var json: Any {
        let nsDictionary = NSMutableDictionary(dictionary: [
            "id": "\(id)",
            "text": "\(text)",
            "importance": "\(importance)",
            "deadline": "\(deadline?.timeIntervalSince1970)",
            "isComplete": "\(isComplete)",
            "dateCreated": "\(dateCreated.timeIntervalSince1970)",
            "dateChanged": "\(dateChanged?.timeIntervalSince1970)",
        ])
        if importance == .ordinary {
            nsDictionary.removeObject(forKey: "importance")
        }
        if deadline == nil {
            nsDictionary.removeObject(forKey: "deadline")
        }
        
        return nsDictionary
    }
    
    static func parse(json: Any) -> ToDoItem? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let dictFromJSON = decoded as? [String: String] {
                if let dateChangedFromJSON = dictFromJSON["dateChanged"], let deadlineFromJSON = dictFromJSON["deadline"] {
                    return ToDoItem(text: dictFromJSON["text"]!,
                                    importance: Importance.convertFromString(string: dictFromJSON["importance"]!),
                                    deadline: Date(timeIntervalSince1970: TimeInterval(Float(deadlineFromJSON)!)),
                                    isComplete: (dictFromJSON["isComplete"] != nil),
                                    dateCreated: Date(timeIntervalSince1970:  TimeInterval(dictFromJSON["dateCreated"]!)!),
                                    dateChanged: Date(timeIntervalSince1970: TimeInterval(Float(dateChangedFromJSON)!)))
                } else {
                    return ToDoItem(text: dictFromJSON["text"]!,
                                    importance: Importance.convertFromString(string: dictFromJSON["importance"]!),
                                    deadline: nil,
                                    isComplete: (dictFromJSON["isComplete"] != nil),
                                    dateCreated: Date(timeIntervalSince1970:  TimeInterval(dictFromJSON["dateCreated"]!)!),
                                    dateChanged: nil)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
