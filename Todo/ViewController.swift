//
//  ViewController.swift
//  Todo
//
//  Created by Thinh Luong on 12/14/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import UIKit
import Alamofire

/// Root ViewController showing the list of Todo objects from mongodb.
class ViewController: UIViewController {
  
  // MARK: Segues
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == SegueIdentifier.ShowDetailViewController, let cell = sender as? CustomCell, let detailVC = segue.destinationViewController as? DetailViewController {
      detailVC.todo = cell.todo
    }
  }
  
  // MARK: Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: Functions
  /**
  Retrieve the Todo collection from mongodb and reload the tableview.
  */
  func downloadAndUpdate() {
    showActivityIndicator(activityIndicator)
    
    Alamofire.request(.GET, MongoDB.url).responseJSON {
      response in
      
      print("GET request result: \(response.result.description)")    // result of response serialization
      
      hideActivityIndicator(self.activityIndicator)
      self.activityIndicator.stopAnimating()
      
      if response.result.description == MongoDB.Request.failure {
        showAlert("Failure! Could not connect to mongoDB.", target: self)
      }
      
      guard let json = response.result.value as? NSMutableArray else {
        return
      }
      
      self.todoManager.clearTodos()
      
      for item in json {
        if let id = item[MongoDB.TodoSchema.id] as? String, let version = item[MongoDB.TodoSchema.version] as? Int, let name = item[MongoDB.TodoSchema.name] as? String, let content = item[MongoDB.TodoSchema.content] as! String?, let dateString = item[MongoDB.TodoSchema.date] as? String {
          
          let date = self.getDateFromString(dateString)
          
          self.todoManager.addTodo(id, version: version, name: name, content: content, date: date)
        }
      }
      self.tableView.reloadData()
    }
    
  }
  
  /**
   Convert a string into a NSDate.
   
   - parameter dateString: date of type String
   
   - returns: date of type NSDate
   */
  func getDateFromString(dateString: String) -> NSDate? {
    if dateString == MongoDB.TodoSchema.dateNil {
      return nil
    } else {
      return dateFormatter.dateFromString(dateString)
    }
  }
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    todoManager = TodoManager()
    
    dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = MongoDB.TodoSchema.dateFormat
    
    activityIndicator.color = UIColor.darkGrayColor()
    activityIndicator.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
    activityIndicator.hidden = true
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    downloadAndUpdate()
  }
  
  // MARK: Properties
  /// TodoManager managing all the todo objects.
  var todoManager: TodoManager!
  var dateFormatter: NSDateFormatter!
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoManager.todos.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! CustomCell
    
    cell.textLabel?.text = todoManager.getTodoAtIndex(indexPath.row).name
    
    cell.todo = todoManager.getTodoAtIndex(indexPath.row)
    
    return cell
    
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      
      showActivityIndicator(activityIndicator)
      
      let urlWithID = MongoDB.url + "/" + todoManager.getTodoAtIndex(indexPath.row).id
      
      Alamofire.request(.DELETE, urlWithID).responseString {
        response in
        
        print("DELETE response result: \(response.result.description)")
        
        hideActivityIndicator(self.activityIndicator)
        
        if response.result.description == MongoDB.Request.failure {
          showAlert("Failure! Could not delete from mongoDB.", target: self)
        } else {
          
          self.todoManager.removeTodoAtIndex(indexPath.row)
          self.tableView.reloadData()
          self.downloadAndUpdate()
          
        }
      }
    }
  }
}


































