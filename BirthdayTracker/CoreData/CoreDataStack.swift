//
//  CoreDataStack.swift
//  BirthdayTracker
//
//  Created by Анастасия Лагарникова on 17.07.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation
import CoreData
 
final class CoreDataStack {
  
  static var shared = CoreDataStack()
  init() {}

  lazy var persistentContainer: NSPersistentContainer = {

      let container = NSPersistentContainer(name: "BirthdayTracker")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {

              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
  }()

  // MARK: - Core Data Saving support
  func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
          do {
              try context.save()
          } catch {
              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
      }
  }
}
