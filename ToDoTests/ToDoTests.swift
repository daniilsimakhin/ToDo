//
//  ToDoTests.swift
//  ToDoTests
//
//  Created by Даниил Симахин on 15.08.2022.
//

import XCTest
@testable import ToDo

class ToDoTests: XCTestCase {
    
    var toDoItem: ToDoItem!

    override func setUpWithError() throws {
        try super.setUpWithError()
        toDoItem = ToDoItem(id: UUID().uuidString, text: "Hello", importance: .ordinary, deadline: nil, isComplete: false, dateCreated: Date(), dateChanged: nil)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        toDoItem = nil
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssert(!toDoItem.isComplete, "isComplete == true")
        XCTAssertNil(toDoItem.dateChanged, "dateChanged != nil")
        XCTAssertNil(toDoItem.deadline, "dateChanged != nil")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testScoreIsComputedWhenGuessIsHigherThanTarget() {
      // given
        let item1 = ToDoItem(id: UUID().uuidString, text: "Hello guy", importance: .ordinary, deadline: nil, isComplete: false, dateCreated: Date(), dateChanged: nil)

      // when

      // then
        XCTAssertEqual(item1.text, "Hello guy")
        XCTAssertEqual(item1.importance, .ordinary)
        XCTAssertNil(item1.deadline)
        XCTAssertFalse(item1.isComplete)
        XCTAssertNil(item1.dateChanged)
    }
}
