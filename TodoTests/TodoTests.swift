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
  
  // MARK: Lifecycle
  override func setUp() {
    super.setUp()
    
    viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as! ViewController
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: Properties
  var viewController: ViewController!
  var mockTodoManager: TodoManager!
  
}
