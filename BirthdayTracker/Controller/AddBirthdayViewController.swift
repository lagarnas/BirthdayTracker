//
//  ViewController.swift
//  BirthdayTracker
//
//  Created by Анастасия Лагарникова on 23.04.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

protocol AddBirthdayViewControllerDelegate: class {
  func addBirthday(didAddBirthday birthday: Birthday, from addBirthdayVievController: AddBirthdayViewController)
}

class AddBirthdayViewController: UIViewController {
  @IBOutlet var firstNameTextField: UITextField!
  @IBOutlet var lastNameTextField: UITextField!
  @IBOutlet var birthdatePicker: UIDatePicker!
  
  weak var delegate: AddBirthdayViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    birthdatePicker.maximumDate = Date()
  }
  
  @IBAction func saveTapped(_ sender: UIBarButtonItem) {
    let firstName = firstNameTextField.text ?? ""
    let lastName = lastNameTextField.text ?? ""
    let birthdate = birthdatePicker.date
    
    let context = getContext()
    
    guard let entity = NSEntityDescription.entity(forEntityName: "Birthday", in: context) else { return }
    
    let newBirthdayObject = Birthday(entity: entity, insertInto: context)
    
    newBirthdayObject.firstName = firstName
    newBirthdayObject.lastName = lastName
    newBirthdayObject.birthdate = birthdate as Date?
    newBirthdayObject.birthdayId = UUID().uuidString
    
    if let uniqueId = newBirthdayObject.birthdayId {
      print("birthdayId:", uniqueId)
    }
    
    do {
      //сохранение в бд
      try context.save()
      delegate?.addBirthday(didAddBirthday: newBirthdayObject, from: self)
      //notification
      let message = "Сегодня \(firstName) \(lastName) празднует день рождения!"
      let content = UNMutableNotificationContent()
      content.body = message
      content.sound = .default
      
      var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthdate)
      dateComponents.hour = 10
      dateComponents.minute = 57
      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
      if let identifier = newBirthdayObject.birthdayId {
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
        
      }
    }
    catch let error as NSError {
      print(error.localizedDescription)
    }
    
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  private func getContext() -> NSManagedObjectContext {
    return CoreDataStack.shared.persistentContainer.viewContext
  }
  
  
}

