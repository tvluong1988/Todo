//
//  File.swift
//  Todo
//
//  Created by Thinh Luong on 12/15/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//
import Foundation

/// Todo object.
class Todo {
  
  // MARK: Lifecycle
  /**
  Initialize with specified parameters.
  
  - parameter id:      primary key id from mongodb
  - parameter version: version number from mongodb
  - parameter name:    name of Todo
  - parameter content: detail description of Todo
  - parameter date:    deadline of Todo
  
  - returns: Todo object
  */
  init(id: String, version: Int, name: String, content: String?, date: NSDate?) {
    self.id = id
    self.version = version
    self.name = name
    self.content = content
    self.date = date
  }
  
  // MARK: Properties
 /// primary key id from mongodb
  let id: String
 /// version number from mongodb
  var version: Int
 /// name of Todo
  var name: String
 /// detail description of Todo
  var content: String?
 /// deadline of Todo
  var date: NSDate?
  
}