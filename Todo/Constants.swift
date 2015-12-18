//
//  Constants.swift
//  Todo
//
//  Created by Thinh Luong on 12/18/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import Foundation

/**
 *  URL Struct holding the url to the mongodb.
 */
struct MongoDB {
  static let url = "https://vast-savannah-5369.herokuapp.com/todo"
  
  /**
   *  Result of Request.
   */
  struct Request {
    static let success = "SUCCESS"
    static let failure = "FAILURE"
  }
  
  /**
   *  Todo object schema for mongodb.
   */
  struct TodoSchema {
    static let headers    = ["Content-Type": "application/json"]
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static let dateNil    = "nil"
    static let id         = "_id"
    static let version    = "__v"
    static let name       = "name"
    static let content    = "content"
    static let date       = "date"
  }
}

/**
 *  Segue Identifiers
 */
struct SegueIdentifier {
  static let ShowAddViewController    = "ShowAddViewController"
  static let ShowDetailViewController = "ShowDetailViewController"
  static let ShowEditViewController   = "ShowEditViewController"
}
