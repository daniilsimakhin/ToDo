//
//  FileCache.swift
//  ToDo
//
//  Created by Даниил Симахин on 12.08.2022.
//

import Foundation

struct FileCache {
    var toDoItems = [ToDoItem]()
    
    mutating func addNewItem(item: ToDoItem) {
        toDoItems.append(item)
    }
    
    mutating func deleteItem(id: String) {
        for (index, values) in toDoItems.enumerated() {
            if values.id == id {
                toDoItems.remove(at: index)
                return
            }
        }
        fatalError("don't delete item")
    }
    
    func saveItems() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask).first {
            let pathWithFilename = documentDirectory.appendingPathComponent("ToDoItems.json")
            let jsonItems = toDoItems.map { item in
                item.json as! NSMutableDictionary
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonItems, options: [])
                try jsonData.write(to: pathWithFilename, options: [])
            } catch {
                print("Error with saving items, \(error.localizedDescription)")
            }
        }
    }
}

