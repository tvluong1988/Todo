//
//  DetailViewController.swift
//  Todo
//
//  Created by Thinh Luong on 12/15/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import UIKit

/// DetailViewController shows the Todo object.
class DetailViewController: UIViewController {
  
  // MARK: Segues
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == SegueIdentifier.ShowEditViewController, let modifyVC = segue.destinationViewController as? AddViewController {
      modifyVC.todo = todo
      modifyVC.mode = .Edit
    }
  }
  
  // MARK: Outlets
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var daysLabel: UILabel!
  @IBOutlet weak var hoursLabel: UILabel!
  @IBOutlet weak var minutesLabel: UILabel!
  @IBOutlet weak var secondsLabel: UILabel!
  
  @IBOutlet var timeLeftLabels: [UILabel]!
  
  // MARK: Functions
  /**
  Update the days, hours, minutes, and seconds label with the time left until the deadline of the Todo object.
  */
  func updateTimeLeft() {
    
    guard var timeLeft = todo.date?.timeIntervalSinceNow else {
      return
    }
    
    if timeLeft < 0 {
      timer?.invalidate()
      timer = nil
      
      for label in [daysLabel, hoursLabel, minutesLabel, secondsLabel] {
        label.text = 0.description
      }
      
      return
    }
    
    timeLeft = floor(timeLeft)
    
    let days = Int(floor(timeLeft / (24*60*60)))
    daysLabel.text = days.description
    
    timeLeft = timeLeft % (24*60*60)
    let hours = Int(floor(timeLeft / (60*60)))
    hoursLabel.text = hours.description
    
    timeLeft = timeLeft % (60*60)
    let minutes = Int(floor(timeLeft / (60)))
    minutesLabel.text = minutes.description
    
    timeLeft = timeLeft % 60
    secondsLabel.text = Int(floor(timeLeft)).description
  }
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    nameLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
    textView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    nameLabel.text = todo.name
    textView.text = todo.content
    
    if todo.date != nil {
      for label in timeLeftLabels {
        label.hidden = false
      }
      
      updateTimeLeft()
      
      timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimeLeft", userInfo: nil, repeats: true)
    } else {
      for label in timeLeftLabels {
        label.hidden = true
      }
    }
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    
    timer?.invalidate()
    timer = nil
  }
  
  // MARK: Properties
  /// Todo object to display.
  var todo: Todo!
  /// Timer that updates the time labels every second.
  var timer: NSTimer?
}
