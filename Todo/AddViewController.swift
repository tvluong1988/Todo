//
//  AddViewController.swift
//  Todo
//
//  Created by Thinh Luong on 12/14/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import UIKit
import Alamofire

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
    
    showActivityIndicator()
    
    let headers = ["Content-Type": "application/json"]
    
    var parameters = [String: AnyObject]()
    parameters["name"] = nameTextField.text!
    parameters["content"] = contentTextView.text
    parameters["date"] = getStringFromDatePicker()
    
    switch navigationItem.title! {
    case "Add Todo":
      Alamofire.request(.POST, URL.App, parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers).responseString {
        response in
        
        print("POST response result: \(response.result)")
        
        self.hideActivityIndicator()
        
        if response.result.description == "SUCCESS" {
          self.resetForm()
          self.showAlert("Success! Added to mongoDB.")
        } else {
          self.showAlert("Failure! Could not add to mongoDB.")
        }
        
      }
      
    case "Modify Todo":
      let urlWithID = URL.App + "/\(todo!.id)"
      parameters["__v"] = todo!.version
      
      Alamofire.request(.PUT, urlWithID, parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers).responseString {
        response in
        
        print("PUT response result: \(response.result)")
        
        self.hideActivityIndicator()
        
        if response.result.description == "SUCCESS" {
          self.navigationController?.popToRootViewControllerAnimated(true)
        } else {
          self.showAlert("Failure! Could not update to mongoDB.")
        }
        
      }
      
    default: break
      
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
  func resetForm() {
    nameTextField.text = nil
    contentTextView.text = ""
    
    deadlineSwitch.on = false
    datePicker.hidden = true
    addButton.enabled = false
    doneButton.enabled = false
    
    view.endEditing(true)
    
  }
  
  func getStringFromDatePicker() -> String {
    
    guard deadlineSwitch.on else {
      return "nil"
    }
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = Date.Format
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
    
    if editMode {
      addButton.setTitle("Modify", forState: .Normal)
      navigationItem.title = "Modify Todo"
    } else {
      addButton.setTitle("Add", forState: .Normal)
      navigationItem.title = "Add Todo"
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
    editMode = false
  }
  
  // MARK: Properties
  var todo: Todo?
  var editMode = false
}

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

// MARK: Helpers
extension AddViewController {
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














