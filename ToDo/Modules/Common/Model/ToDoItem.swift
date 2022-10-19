//
//  ToDoItem.swift
//  ToDo
//
//  Created by Даниил Симахин on 11.08.2022.
//

import Foundation

enum Importance: String {
    case unimportant
    case ordinary
    case important
    
    static func convertFromString(string: String) -> Importance {
        switch string {
        case Importance.unimportant.rawValue:
            return .unimportant
        case Importance.ordinary.rawValue:
            return .ordinary
        case Importance.important.rawValue:
            return .important
        default:
            fatalError("convertFromString -> вернул дефолтное значение")
        }
    }
    
    static func convertFromIndex(index: Int) -> Importance {
        switch index {
        case 0:
            return .unimportant
        case 1:
            return .ordinary
        case 2:
            return .important
        default:
            fatalError("convertFromIndex -> вернул дефолтное значение")
        }
    }
}

struct ToDoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    var isComplete: Bool
    let dateCreated: Date
    let dateChanged: Date?
    
}

extension ToDoItem {
    var json: Any {
        let nsDictionary = NSMutableDictionary(dictionary: [
            "id": "\(id)",
            "text": "\(text)",
            "importance": "\(importance)",
            "deadline": "\(deadline?.timeIntervalSince1970 ?? 0)",
            "isComplete": "\(isComplete)",
            "dateCreated": "\(dateCreated.timeIntervalSince1970)",
            "dateChanged": "\(dateChanged?.timeIntervalSince1970 ?? 0)",
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
                            isComplete: Bool(dictFromJSON["isComplete"]!)!,
                            dateCreated: Date(timeIntervalSince1970: TimeInterval(dictFromJSON["dateCreated"]!)!),
                            dateChanged: dateChanged)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
