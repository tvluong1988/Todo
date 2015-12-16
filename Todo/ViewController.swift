//
//  ViewController.swift
//  Todo
//
//  Created by Thinh Luong on 12/14/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import UIKit
import Alamofire

struct URL {
  static let App = "https://vast-savannah-5369.herokuapp.com/todo"
}

struct Date {
  static let Format = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
}

class ViewController: UIViewController {
  
  // MARK: Segues
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowDetailViewController", let cell = sender as? CustomCell, let detailVC = segue.destinationViewController as? DetailViewController {
      detailVC.todo = cell.todo
    }
  }
  
  // MARK: Outlets
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: Functions
  func downloadAndUpdate() {
    showActivityIndicator()
    
    Alamofire.request(.GET, URL.App).responseJSON {
      response in
      
      print("GET request result: \(response.result.description)")    // result of response serialization
      
      self.hideActivityIndicator()
      self.activityIndicator.stopAnimating()
      
      if response.result.description == "FAILURE" {
        self.showAlert("Failure! Could not connect to mongoDB.")
      }
      
      guard let json = response.result.value as? NSMutableArray else {
        return
      }
      
      self.todoManager.clearTodos()

      for item in json {
        if let id = item["_id"] as? String, let version = item["__v"] as? Int, let name = item["name"] as? String, let content = item["content"] as! String?, let dateString = item["date"] as? String {
          
          let date = self.getDateFromString(dateString)
          
          self.todoManager.addTodo(id, version: version, name: name, content: content, date: date)
        }
      }
      self.tableView.reloadData()
    }
    
  }
  
  func getDateFromString(dateString: String) -> NSDate? {
    if dateString == "nil" {
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
    dateFormatter.dateFormat = Date.Format
    
    activityIndicator.color = UIColor.darkGrayColor()
    activityIndicator.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
    activityIndicator.hidden = true
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    downloadAndUpdate()
  }
  
  // MARK: Properties
  var todoManager: TodoManager!
  var dateFormatter: NSDateFormatter!
//  var activityIndicator: UIActivityIndicatorView?


}

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
      
      showActivityIndicator()
      
      let urlWithID = URL.App + "/" + todoManager.getTodoAtIndex(indexPath.row).id
      
      Alamofire.request(.DELETE, urlWithID).responseString {
        response in
        
        print("DELETE response result: \(response.result.description)")
        
        self.hideActivityIndicator()
        
        if response.result.description == "FAILURE" {
          self.showAlert("Failure! Could not delete from mongoDB.")
        } else {
          
          self.todoManager.removeTodoAtIndex(indexPath.row)
          self.tableView.reloadData()
          self.downloadAndUpdate()

        }
      }
    }
  }
}

// MARK: Helpers
extension ViewController {
  /**
   Add and show an activity indicator onscreen.
   */
  func showActivityIndicator() {
    activityIndicator.hidden = false
    activityIndicator.startAnimating()
  }
  
  /**
   Hide and remove an activity indicator.
   */
  func hideActivityIndicator() {
    activityIndicator.stopAnimating()
    activityIndicator.hidden = true
  }
  
  /**
   Create and show AlertView
   
   - Parameter message: Message to display to user.
   
   */
  func showAlert(message: String) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
    let okButton = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
    alert.addAction(okButton)
    
    presentViewController(alert, animated: true, completion: nil)
  }
}

































