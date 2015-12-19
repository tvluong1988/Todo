//
//  TodoUITests.swift
//  TodoUITests
//
//  Created by Thinh Luong on 12/14/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import XCTest
import UIKit

class TodoUITests: XCTestCase {
  
  // MARK: Tests
  func testExistence() {
    XCTAssert(app.navigationBars["Todo List"].exists)
  }
  
  func testAddTodo() {
    let addButton = app.buttons["Add"]
    let doneButton = app.buttons["Done"]
    let nameTextField = app.textFields["required"]
    let contentTextView = app.textViews.elementBoundByIndex(0)
    let deadlineSwitch = app.switches["DeadlineSwitch"]
    let keyboardReturnButton = app.buttons["Return"]
    
    let todoName = "Workout at the gym"
    
    let addTodoTitle = app.navigationBars.staticTexts["Add Todo"]
    expectationForPredicate(exists, evaluatedWithObject: addTodoTitle, handler: nil)
    
    addButton.tap()
    
    waitForExpectationsWithTimeout(2, handler: nil)
    
    XCTAssert(addTodoTitle.exists)
    XCTAssert(addButton.enabled == false)
    XCTAssert(doneButton.enabled == false)
    
    nameTextField.tap()
    nameTextField.typeText(todoName)
    keyboardReturnButton.tap()
    
    XCTAssert(addButton.enabled)
    XCTAssert(doneButton.enabled == false)
    
    contentTextView.tap()
    XCTAssert(doneButton.enabled)
    
    let content = ("Treadmill for 10 minutes.", "Do 20 pushups.", "Grab some pizza on the way home.")
    
    contentTextView.typeText(content.0)
    keyboardReturnButton.tap()
    contentTextView.typeText(content.1)
    keyboardReturnButton.tap()
    contentTextView.typeText(content.2)
    keyboardReturnButton.tap()
    
    doneButton.tap()
    
    XCTAssert(doneButton.enabled == false)
    
    deadlineSwitch.tap()
    
    let date = (day: "Dec 31", hour: "3", minute: "30", am: "AM")
    
    let datePicker = app.datePickers.elementBoundByIndex(0)
    datePicker.pickerWheels.elementBoundByIndex(0).adjustToPickerWheelValue(date.day)
    datePicker.pickerWheels.elementBoundByIndex(1).adjustToPickerWheelValue(date.hour)
    datePicker.pickerWheels.elementBoundByIndex(2).adjustToPickerWheelValue(date.minute)
    datePicker.pickerWheels.elementBoundByIndex(3).adjustToPickerWheelValue(date.am)
    
    addButton.tap()
    
    app.alerts.buttons["OK"].tap()
    
    
    
    let todoCell = app.tables.element.cells.staticTexts[todoName]
    
    expectationForPredicate(exists, evaluatedWithObject: todoCell, handler: nil)
    app.navigationBars.buttons["Todo List"].tap()
    
    waitForExpectationsWithTimeout(2, handler: nil)
    XCTAssert(todoCell.exists)
    
    todoCell.tap()
    
    for textLabel in [todoName, "Days", "Hours", "Minutes", "Seconds left"] {
      XCTAssert(app.staticTexts[textLabel].exists)
    }
    
    let editTodoTitle = app.navigationBars.staticTexts["Edit Todo"]
    expectationForPredicate(exists, evaluatedWithObject: editTodoTitle, handler: nil)
    
    app.navigationBars.buttons["Edit"].tap()
    
    waitForExpectationsWithTimeout(2, handler: nil)
    
    XCTAssert(editTodoTitle.exists)
    XCTAssert(nameTextField.value != nil)
    XCTAssert(contentTextView.value != nil)
    
    nameTextField.tap()
    nameTextField.typeText(" Updated")
    
    app.buttons["Return"].tap()
    
    deadlineSwitch.tap()
    
    app.buttons["Edit"].tap()
    
    let updatedTodoName = todoName + " Updated"
    let updatedTodoCell = app.tables.element.cells.staticTexts[updatedTodoName]
    expectationForPredicate(exists, evaluatedWithObject: updatedTodoCell, handler: nil)
    
    waitForExpectationsWithTimeout(2, handler: nil)
    
    XCTAssert(updatedTodoCell.exists)
    
    updatedTodoCell.tap()
    
    XCTAssert(app.staticTexts[updatedTodoName].exists)
    
    app.navigationBars.buttons["Todo List"].tap()
    
    updatedTodoCell.swipeLeft()
    expectationForPredicate(doesNotExists, evaluatedWithObject: updatedTodoCell, handler: nil)
    
    app.tables.element.buttons["Delete"].tap()
    
    waitForExpectationsWithTimeout(3, handler: nil)
    
    XCTAssert(updatedTodoCell.exists == false)
  }
  
  // MARK: Lifecycle
  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    app.launch()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: Properties
  let app = XCUIApplication()
  let exists = NSPredicate(format: "exists == true")
  let doesNotExists = NSPredicate(format: "exists == false")
}




























