//
//  TaskService.swift
//  ToDo
//
//  Created by Даниил Симахин on 12.08.2022.
//
import Foundation

protocol TaskBaseService {
    var tasks: [Task] { get }
    
    func appendTask(task: Task, indexPath: IndexPath?)
    func deleteTask(id: String)
    func replaceTask(indexPath: IndexPath)
    func replaceTask(task: Task)
    func saveTasks()
    func loadTasks()
}

class TaskService: TaskBaseService {
    
    var tasks = [Task]()
    
    private var filePath: URL? {
        let fileName = "ToDoTasks.json"
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        return fileUrl
    }
    
    func replaceTask(task: Task) {
        loadTasks()
        for (index, value) in tasks.enumerated() {
            if value.id == task.id {
                let newTask = Task(id: task.id, text: task.text, importance: task.importance, deadline: task.deadline, isComplete: !task.isComplete, dateCreated: task.dateCreated, dateChanged: task.dateChanged)
                tasks[index] = newTask
                saveTasks()
                return
            }
        }
    }
    
    func replaceTask(indexPath: IndexPath) {
        loadTasks()
        let task = tasks[indexPath.row]
        for (index, value) in tasks.enumerated() {
            if value.id == task.id {
                let newTask = Task(id: task.id, text: task.text, importance: task.importance, deadline: task.deadline, isComplete: !task.isComplete, dateCreated: task.dateCreated, dateChanged: task.dateChanged)
                tasks[index] = newTask
                saveTasks()
                return
            }
        }
    }
    
    func appendTask(task: Task, indexPath: IndexPath?) {
        var task = task
        while tasks.contains(where: { $0.id == task.id }) {
            task = Task(id: UUID().uuidString, text: task.text, importance: task.importance, deadline: task.deadline, isComplete: task.isComplete, dateCreated: task.dateCreated, dateChanged: task.dateChanged)
        }
        if let index = indexPath?.row {
            tasks.insert(task, at: index)
        } else {
            switch task.importance {
            case .important:
                tasks.insert(task, at: 0)
            case .ordinary:
                let index = tasks.reduce(0) { $1.importance == .important ? $0 + 1 : $0 + 0 }
                tasks.insert(task, at: index)
            case .unimportant:
                let index = tasks.reduce(0) { $1.importance == .ordinary || $1.importance == .important ? $0 + 1 : $0 + 0 }
                tasks.insert(task, at: index)
            }
        }
    }
    
    func deleteTask(id: String) {
        for (index, task) in tasks.enumerated() {
            if task.id == id {
                tasks.remove(at: index)
                return
            }
        }
        fatalError("No such task id exists")
    }
    
    func saveTasks() {
        guard let fileURL = filePath else { return }
        do {
            let data = try JSONEncoder().encode(tasks)
            try data.write(to: fileURL)
        } catch {
            print("Error with saving tasks to JSON, \(error.localizedDescription)")
        }
    }
    
    func loadTasks() {
        guard let fileURL = filePath else { return }
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("File is not exist")
            return
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let json = try JSONDecoder().decode([Task].self, from: data)
            tasks = json
        } catch {
            print("Error with loading tasks from JSON, \(error.localizedDescription)")
        }
    }
}
