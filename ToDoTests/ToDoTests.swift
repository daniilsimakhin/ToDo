//
//  ToDoTests.swift
//  ToDoTests
//
//  Created by Даниил Симахин on 15.08.2022.
//

import XCTest
@testable import ToDo

class ToDoTests: XCTestCase {
    
    var toDoTask: Task!

    override func setUpWithError() throws {
        try super.setUpWithError()
        toDoTask = Task(id: UUID().uuidString, text: "Hello", importance: .ordinary, deadline: nil, isComplete: false, dateCreated: Date(), dateChanged: nil)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        toDoTask = nil
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssert(!toDoTask.isComplete, "isComplete == true")
        XCTAssertNil(toDoTask.dateChanged, "dateChanged != nil")
        XCTAssertNil(toDoTask.deadline, "dateChanged != nil")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testScoreIsComputedWhenGuessIsHigherThanTarget() {
      // given
        let task1 = Task(id: UUID().uuidString, text: "Hello guy", importance: .ordinary, deadline: nil, isComplete: false, dateCreated: Date(), dateChanged: nil)

      // when

      // then
        XCTAssertEqual(task1.text, "Hello guy")
        XCTAssertEqual(task1.importance, .ordinary)
        XCTAssertNil(task1.deadline)
        XCTAssertFalse(task1.isComplete)
        XCTAssertNil(task1.dateChanged)
    }
}
