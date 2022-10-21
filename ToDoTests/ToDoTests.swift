//
//  ToDoTests.swift
//  ToDoTests
//
//  Created by Даниил Симахин on 15.08.2022.
//

import XCTest
@testable import ToDo

class ToDoTests: XCTestCase {
    
    func testTask1() {
        let dateCreated = Date()
        let task = Task(id: "01", text: "Hello guy", importance: .ordinary, deadline: nil, isComplete: false, dateCreated: dateCreated, dateChanged: nil)
        
        XCTAssertEqual(task.id, "01")
        XCTAssertEqual(task.text, "Hello guy")
        XCTAssertEqual(task.importance, .ordinary)
        XCTAssertNil(task.deadline)
        XCTAssertFalse(task.isComplete)
        XCTAssertEqual(task.dateCreated, dateCreated)
        XCTAssertNil(task.dateChanged)
    }
    
    func testTask2() {
        let dateCreated = Date()
        let dateChanged = Date()
        let task = Task(id: "02", text: "", importance: .important, deadline: Date.tomorrow, isComplete: true, dateCreated: dateCreated, dateChanged: dateChanged)
        
        XCTAssertEqual(task.id, "02")
        XCTAssertEqual(task.text, "")
        XCTAssertEqual(task.importance, .important)
        XCTAssertEqual(task.deadline, Date.tomorrow)
        XCTAssertTrue(task.isComplete)
        XCTAssertEqual(task.dateCreated, dateCreated)
        XCTAssertEqual(task.dateChanged, dateChanged)
    }
    
    func testTaskService() {
        let task1 = Task(id: "1", text: "1", importance: .ordinary, deadline: nil, isComplete: true, dateCreated: Date(), dateChanged: Date())
        let task2 = Task(id: "2", text: "2", importance: .important, deadline: Date.tomorrow, isComplete: true, dateCreated: Date(), dateChanged: Date())
        let task3 = Task(id: "3", text: "3", importance: .unimportant, deadline: nil, isComplete: false, dateCreated: Date(), dateChanged: nil)
        
        let taskService = TaskService()
        XCTAssertEqual(taskService.tasks.count, 0)
        taskService.appendTask(task: task1, indexPath: nil)
        taskService.appendTask(task: task2, indexPath: nil)
        taskService.appendTask(task: task3, indexPath: nil)
        XCTAssertEqual(taskService.tasks.count, 3)
        taskService.deleteTask(id: "1")
        XCTAssertEqual(taskService.tasks.count, 2)
    }
}
