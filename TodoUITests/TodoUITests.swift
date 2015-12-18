//
//  TodoUITests.swift
//  TodoUITests
//
//  Created by Thinh Luong on 12/14/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import XCTest

class TodoUITests: XCTestCase {
  
  // MARK: Tests
  
  
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
  
}
