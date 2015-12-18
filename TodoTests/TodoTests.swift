//
//  TodoTests.swift
//  TodoTests
//
//  Created by Thinh Luong on 12/14/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import XCTest
@testable import Todo

class TodoTests: XCTestCase {
  
  // MARK: Tests
  func testAddTodo_GetTodo() {
    
    mockTodoManager.addTodo(testTodo1.id, version: testTodo1.version, name: testTodo1.name, content: testTodo1.content, date: testTodo1.date)
    mockTodoManager.addTodo(testTodo2.id, version: testTodo2.version, name: testTodo2.name, content: testTodo2.content, date: testTodo2.date)
    
    let todo1 = mockTodoManager.getTodoAtIndex(0)
    let todo2 = mockTodoManager.getTodoAtIndex(1)
    
    XCTAssert(testTodo1 == todo1)
    XCTAssert(testTodo2 == todo2)
  }
  
  func testRemoveTodo() {
    mockTodoManager.todos.append(testTodo1)
    mockTodoManager.removeTodoAtIndex(0)
    
    XCTAssert(mockTodoManager.todos.count == 0)
  }
  
  func testClearTodos() {
    mockTodoManager.todos.append(testTodo1)
    mockTodoManager.todos.append(testTodo2)
    
    mockTodoManager.clearTodos()
    
    XCTAssert(mockTodoManager.todos.count == 0)
  }
  
  func testConvertDateToString_DeadlineSwitchOff() {
    let testDate = NSDate(timeIntervalSince1970: 1000)
    
    let deadlineSwitch = UISwitch()
    addViewController.deadlineSwitch = deadlineSwitch
    
    deadlineSwitch.on = false
    
    let dateString = addViewController.convertDateToString(testDate)
    
    XCTAssert(dateString == MongoDB.TodoSchema.dateNil)
  }
  
  func testConvertDateToString_DeadlineSwitchOn() {
    let testDate = NSDate(timeIntervalSince1970: 1000)
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = MongoDB.TodoSchema.dateFormat
    let testDateString = dateFormatter.stringFromDate(testDate)
    
    let deadlineSwitch = UISwitch()
    addViewController.deadlineSwitch = deadlineSwitch
    
    deadlineSwitch.on = true
    
    let dateString = addViewController.convertDateToString(testDate)
    
    XCTAssert(dateString == testDateString)
  }
  
  func testConvertStringToDate() {
    let dateString = MongoDB.TodoSchema.dateNil
    let invalidDate = viewController.convertStringToDate(dateString)
    
    XCTAssert(invalidDate == nil)
    
    let testDate = NSDate(timeIntervalSince1970: 1000)
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = MongoDB.TodoSchema.dateFormat
    let testDateString = dateFormatter.stringFromDate(testDate)
    
    let validDate = viewController.convertStringToDate(testDateString)
    
    XCTAssert(validDate == testDate)
  }
  
  func testCalculateTimeLeft() {
    var timeLeft: NSTimeInterval = 0
    timeLeft += 60*60*24
    timeLeft += 60*60
    timeLeft += 60
    timeLeft += 6
    
    let time = detailViewController.calculateTimeLeft(timeLeft)
    
    XCTAssert(time.daysLeft == 1)
    XCTAssert(time.hoursLeft == 1)
    XCTAssert(time.minutesLeft == 1)
    XCTAssert(time.secondsLeft == 6)
  }
  
  // MARK: Lifecycle
  override func setUp() {
    super.setUp()
    
    viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as! ViewController
    
    addViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AddViewController") as! AddViewController
    
    detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
    
    mockTodoManager = TodoManager()
    
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: Properties
  var viewController: ViewController!
  var addViewController: AddViewController!
  var detailViewController: DetailViewController!
  
  var mockTodoManager: TodoManager!
  let testTodo1 = Todo(id: "testID1", version: 1, name: "testName1", content: "testContent1", date: NSDate(timeIntervalSince1970: 1001))
  let testTodo2 = Todo(id: "testID2", version: 2, name: "testName2", content: "testContent2", date: NSDate(timeIntervalSince1970: 1002))
  
}


















