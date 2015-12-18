//
//  AddViewController.swift
//  Todo
//
//  Created by Thinh Luong on 12/14/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import UIKit
import Alamofire

enum AddViewControllerMode: String {
  case Add
  case Edit
}

/// AddViewController shows the form to add or modify a Todo object.
class AddViewController: UIViewController {
  
  // MARK: Outlets
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var contentTextView: UITextView!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var deadlineSwitch: UISwitch!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: Actions
  
  @IBAction func deadlineSwitch(sender: UISwitch) {
    datePicker.hidden = !sender.on
  }
  
  @IBAction func addButtonPressed(sender: UIButton) {
    
    if nameTextField.text!.isEmpty {
      return
    }
    
    showActivityIndicator(activityIndicator)
    
    var parameters = [String: AnyObject]()
    parameters[MongoDB.TodoSchema.name] = nameTextField.text!
    parameters[MongoDB.TodoSchema.content] = contentTextView.text
    parameters[MongoDB.TodoSchema.date] = getStringFromDatePicker()
    
    switch mode {
    case .Add:
      Alamofire.request(.POST, MongoDB.url, parameters: parameters, encoding: ParameterEncoding.JSON, headers: MongoDB.TodoSchema.headers).responseString {
        response in
        
        print("POST response result: \(response.result)")
        
        hideActivityIndicator(self.activityIndicator)
        
        if response.result.description == MongoDB.Request.success {
          self.resetForm()
          showAlert("Success! Added to mongoDB.", target: self)
        } else {
          showAlert("Failure! Could not add to mongoDB.", target: self)
        }
        
      }
      
    case .Edit:
      let urlWithID = MongoDB.url + "/\(todo!.id)"
      parameters[MongoDB.TodoSchema.version] = todo!.version
      
      Alamofire.request(.PUT, urlWithID, parameters: parameters, encoding: ParameterEncoding.JSON, headers: MongoDB.TodoSchema.headers).responseString {
        response in
        
        print("PUT response result: \(response.result)")
        
        hideActivityIndicator(self.activityIndicator)
        
        if response.result.description == MongoDB.Request.success {
          self.navigationController?.popToRootViewControllerAnimated(true)
        } else {
          showAlert("Failure! Could not update to mongoDB.", target: self)
        }
        
      }      
    }
    
    
    
  }
  
  @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
    contentTextView.resignFirstResponder()
  }
  
  func textViewDidBeginEditing() {
    doneButton.enabled = true
  }
  
  func textViewDidEndEditing() {
    doneButton.enabled = false
  }
  
  // MARK: Functions
  /**
  Set the default value and state of the forms.
  */
  func resetForm() {
    nameTextField.text = nil
    contentTextView.text = ""
    
    deadlineSwitch.on = false
    datePicker.hidden = true
    addButton.enabled = false
    doneButton.enabled = false
    
    view.endEditing(true)
    
  }
  
  /**
   Convert the NSDate from datePicker to a string.
   
   - returns: the date as a string value
   */
  func getStringFromDatePicker() -> String {
    
    guard deadlineSwitch.on else {
      return MongoDB.TodoSchema.dateNil
    }
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = MongoDB.TodoSchema.dateFormat
    return dateFormatter.stringFromDate(datePicker.date)
  }
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nameTextField.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
    contentTextView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
    
    addButton.enabled = false
    doneButton.enabled = false
    
    datePicker.hidden = true
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewDidBeginEditing", name: UITextViewTextDidBeginEditingNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewDidEndEditing", name: UITextViewTextDidEndEditingNotification, object: nil)
    
    activityIndicator.color = UIColor.whiteColor()
    activityIndicator.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
    activityIndicator.hidden = true
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    switch mode {
    case .Add:
      addButton.setTitle("Add", forState: .Normal)
      navigationItem.title = "Add Todo"
    case .Edit:
      addButton.setTitle("Modify", forState: .Normal)
      navigationItem.title = "Modify Todo"
    }
    
    if let todo = todo {
      nameTextField.text = todo.name
      addButton.enabled = true
      
      if let content = todo.content {
        contentTextView.text = content
      }
      
      if let date = todo.date {
        deadlineSwitch.on = true
        datePicker.hidden = false
        datePicker.setDate(date, animated: true)
      }
    }
  }
  
  override func viewDidDisappear(animated: Bool) {
    todo = nil
    mode = .Add
  }
  
  // MARK: Properties
  /// The Todo object to modify.
  var todo: Todo?
  /// Set the AddViewController in Add or Edit mode.
  var mode: AddViewControllerMode = .Add
}

// MARK: - UITextFieldDelegate
extension AddViewController: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    nameTextField.resignFirstResponder()
    
    return true
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    if let text = textField.text where text.isEmpty == false {
      addButton.enabled = true
    } else {
      addButton.enabled = false
    }
  }
}















