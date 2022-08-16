//
//  UnitTest.swift
//  ToDo
//
//  Created by Даниил Симахин on 15.08.2022.
//

import XCTest


class UnitTest: XCTestCase {

    var fileCache: FileCache!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        fileCache = fileCache()
    }

    override func tearDownWithError() throws {
        fileCache = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }

    func testExample() throws {
        let item1 = ToDoItem(id: UUID().uuidString, text: "Drink milk", importance: .ordinary, deadline: nil, isComplete: false, dateCreated: Date(), dateChanged: nil)
        let item2 = ToDoItem(id: UUID().uuidString, text: "Fix table", importance: .important, deadline: Date().timeIntervalSince1970 + 1000, isComplete: false, dateCreated: Date(), dateChanged: nil)
        let item3 = ToDoItem(id: UUID().uuidString, text: "Walk to doctor", importance: .unimportant, deadline: nil, isComplete: false, dateCreated: Date(), dateChanged: Date().timeIntervalSince1970 + 100)
        
        print(fileCache.toDoItems)
        fileCache.addNewItem(item: item1)
        fileCache.addNewItem(item: item2)
        fileCache.addNewItem(item: item3)
        print(fileCache.toDoItems)
        fileCache.saveItems()
        fileCache.deleteItem(id: item1.id)
        print(fileCache.toDoItems)
        fileCache.saveItems()
        fileCache.deleteItem(id: item2.id)
        print(fileCache.toDoItems)
        fileCache.loadItems()
        print(fileCache.toDoItems)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
