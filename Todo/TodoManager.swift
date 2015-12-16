//
//  TodoManager.swift
//  Todo
//
//  Created by Thinh Luong on 12/15/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import Foundation

class TodoManager {
  // MARK: Functions
  func addTodo(id: String, version: Int, name: String, content: String?, date: NSDate?) {
    todos.append(Todo(id: id, version: version, name: name, content: content, date: date))
  }
  
  func removeTodoAtIndex(index: Int) {
    todos.removeAtIndex(index)
  }
  
  func getTodoAtIndex(index: Int) -> Todo {
    return todos[index]
  }
  
  func clearTodos() {
    todos.removeAll()
  }
  
  // MARK: Lifecycle
  init() {
    todos = [Todo]()
  }
  
  // MARK: Properties
  var todos: [Todo]
}