//
//  FileCache.swift
//  ToDo
//
//  Created by Даниил Симахин on 12.08.2022.
//

import Foundation

protocol FileCacheDelegate {
    var toDoTasks: [Task] { get }
    
    func addNewTask(task: Task)
    
    func deleteTask(id: String)
    
    func saveTasks()
    
    func loadTasks()
}

class FileCache: FileCacheDelegate {
    
    var toDoTasks = [Task]()
    
    let fileName = "ToDoTasks.json"
    
    func addNewTask(task: Task) {
        var task = task
        while toDoTasks.contains(where: { toDoTask in
            toDoTask.id == task.id
        }) {
            task = Task(id: UUID().uuidString, text: task.text, importance: task.importance, deadline: task.deadline, isComplete: task.isComplete, dateCreated: task.dateCreated, dateChanged: task.dateChanged)
        }
        if task.importance == .important {
            toDoTasks.insert(task, at: 0)
        } else if task.importance == .unimportant {
            toDoTasks.insert(task, at: toDoTasks.count)
        } else {
            let index = toDoTasks.reduce(0) { $1.importance == .important ? $0 + 1 : $0 + 0 }
            toDoTasks.insert(task, at: index)
        }
    }
    
    func addNewTask(task: Task, indexPath: IndexPath) {
        var task = task
        while toDoTasks.contains(where: { toDoTask in
            toDoTask.id == task.id
        }) {
            task = Task(id: UUID().uuidString, text: task.text, importance: task.importance, deadline: task.deadline, isComplete: task.isComplete, dateCreated: task.dateCreated, dateChanged: task.dateChanged)
        }
        toDoTasks.insert(task, at: indexPath.row)
    }
    
    func deleteTask(id: String) {
        for (index, values) in toDoTasks.enumerated() {
            if values.id == id {
                toDoTasks.remove(at: index)
                return
            }
        }
        fatalError("don't delete task")
    }
    
    func saveTasks() {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        let jsonTasks = toDoTasks.map { $0.json as! NSMutableDictionary }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonTasks, options: [])
            try jsonData.write(to: fileUrl, options: [])
        } catch {
            print("Error with saving tasks to JSON, \(error.localizedDescription)")
        }
    }
    
    func loadTasks() {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let tasks = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] else { return }
            self.toDoTasks = tasks.map{ Task.parse(json: $0)! }
        } catch {
            print("Error with loading tasks from JSON, \(error.localizedDescription)")
        }
    }
}

