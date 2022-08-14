//
//  ToDoItem.swift
//  ToDo
//
//  Created by Даниил Симахин on 11.08.2022.
//

import Foundation

struct ToDoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isComplete: Bool
    let dateCreated: Date
    let dateChanged: Date?
    
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
        if dateChanged == nil {
            nsDictionary.removeObject(forKey: "dateChanged")
        }
        return nsDictionary
    }
    
    static func parse(json: Any) -> ToDoItem? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            guard let dictFromJSON = decoded as? [String: String] else { return nil }
            
            let deadline = dictFromJSON["deadline"] != nil ? Date(timeIntervalSince1970: TimeInterval(Float(dictFromJSON["deadline"]!)!)) : nil
            let dateChanged = dictFromJSON["dateChanged"] != nil ? Date(timeIntervalSince1970: TimeInterval(Float(dictFromJSON["dateChanged"]!)!)) : nil
            
            return ToDoItem(id: dictFromJSON["id"]!,
                            text: dictFromJSON["text"]!,
                            importance: Importance.convertFromString(string: dictFromJSON["importance"] ?? "ordinary"),
                            deadline: deadline,
                            isComplete: (dictFromJSON["isComplete"] != nil),
                            dateCreated: Date(timeIntervalSince1970: TimeInterval(dictFromJSON["dateCreated"]!)!),
                            dateChanged: dateChanged)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
