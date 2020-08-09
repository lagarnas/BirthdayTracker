//
//  BirthdaysTableViewController.swift
//  BirthdayTracker
//
//  Created by Анастасия Лагарникова on 19.05.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import UIKit
import  CoreData
import UserNotifications

class BirthdaysTableViewController: UITableViewController {
  
  var birthdays: [Birthday] = []
  let dateFormatter = DateFormatter()
  
  override func viewWillAppear(_ animated: Bool) {
    print(#function)
    super.viewWillAppear(animated)
    self.tableView.reloadData()
    let context = CoreDataStack.shared.persistentContainer.viewContext
    //запрос на получение данных из бд
    let fetchRequest: NSFetchRequest<Birthday> = Birthday.fetchRequest()
    //or
    
    //Сортировка дней рождения
    let sortDescriptor1 = NSSortDescriptor(key: "lastName", ascending: true) //по возврастанию от А до Я
    let sortDescriptor2 = NSSortDescriptor(key: "firstName", ascending: true)
    
    fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
    
    do {
      birthdays = try context.fetch(fetchRequest)
    }
    catch let error as NSError {
      print(error.localizedDescription)
    }
    
    tableView.reloadData()
    
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()
    dateFormatter.dateStyle = .full
    dateFormatter.timeStyle = .none
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    birthdays.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "birthdayCellIdentifier", for: indexPath)
    let birthday = birthdays[indexPath.row]
    
    let firstName = birthday.firstName ?? ""
    let lastName = birthday.lastName ?? ""
  
    cell.textLabel?.text = firstName + " " + lastName
    
    if let date = birthday.birthdate as Date? {
      cell.detailTextLabel?.text = dateFormatter.string(from: date)
    } else {
      cell.detailTextLabel?.text = ""
    }
  
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    if birthdays.count > indexPath.row {
      let birthday = birthdays[indexPath.row]
      if let identifier = birthday.birthdayId {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
      }
      let context = CoreDataStack.shared.persistentContainer.viewContext
      context.delete(birthday)
      birthdays.remove(at: indexPath.row)
      do {
        try context.save()
      } catch let error as NSError {
        print(error.localizedDescription)
      }
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

          let navigationController = segue.destination as! UINavigationController
          let addBirthdayViewController = navigationController.topViewController as! AddBirthdayViewController
          addBirthdayViewController.delegate = self
      }
}

extension BirthdaysTableViewController: AddBirthdayViewControllerDelegate {
    func addBirthday(didAddBirthday birthday: Birthday, from addBirthdayVievController: AddBirthdayViewController) {
        birthdays.append(birthday)
        tableView.reloadData()
    }

}
