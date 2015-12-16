//
//  File.swift
//  Todo
//
//  Created by Thinh Luong on 12/15/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//
import Foundation

class Todo {
  
  // MARK: Lifecycle
  init(id: String, version: Int, name: String, content: String?, date: NSDate?) {
    self.id = id
    self.version = version
    self.name = name
    self.content = content
    self.date = date
  }
  
  // MARK: Properties
  let id: String
  var version: Int
  var name: String
  var content: String?
  var date: NSDate?
  
}