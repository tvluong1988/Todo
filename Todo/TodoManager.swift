//
//  TodoManager.swift
//  Todo
//
//  Created by Thinh Luong on 12/15/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import Foundation

/// TodoManager manages all the Todo objects.
class TodoManager {
  // MARK: Functions
  /**
  Add a new Todo object.
  
  - parameter id:      primary key id from mongodb
  - parameter version: version number from mongodb
  - parameter name:    name of Todo
  - parameter content: detail description of Todo
  - parameter date:    deadline of Todo
  */
  func addTodo(id: String, version: Int, name: String, content: String?, date: NSDate?) {
    todos.append(Todo(id: id, version: version, name: name, content: content, date: date))
  }
  
  /**
   Remove the Todo object at specified index.
   
   - parameter index: index of Todo object to remove
   */
  func removeTodoAtIndex(index: Int) {
    todos.removeAtIndex(index)
  }
  
  /**
   Retrieve a Todo at the specified index.
   
   - parameter index: index of Todo object to retrieve
   
   - returns: Todo object
   */
  func getTodoAtIndex(index: Int) -> Todo {
    return todos[index]
  }
  
  /**
   Remove all Todo objects from the TodoManager todos array.
   */
  func clearTodos() {
    todos.removeAll()
  }
  
  // MARK: Lifecycle
  /**
  Initializes a TodoManager with an empty todos array.
  
  - returns: TodoManager
  */
  init() {
    todos = [Todo]()
  }
  
  // MARK: Properties
 /// Array of Todo objects.
  var todos: [Todo]
}













