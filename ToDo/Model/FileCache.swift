//
//  FileCache.swift
//  ToDo
//
//  Created by Даниил Симахин on 12.08.2022.
//

import Foundation

struct FileCache {
    var toDoItems = [ToDoItem]()
    let fileName = "ToDoItems.json"
    
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
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        let jsonItems = toDoItems.map { $0.json as! NSMutableDictionary }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonItems, options: [])
            try jsonData.write(to: fileUrl, options: [])
        } catch {
            print("Error with saving items to JSON, \(error.localizedDescription)")
        }
    }
    
    mutating func loadItems() {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let items = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] else { return }
            self.toDoItems = items.map{ ToDoItem.parse(json: $0)! }
        } catch {
            print("Error with loading items from JSON, \(error.localizedDescription)")
        }
    }
}

