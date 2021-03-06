//
//  AppDelegate.swift
//  BirthdayTracker
//
//  Created by Анастасия Лагарникова on 23.04.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
      let center = UNUserNotificationCenter.current()
      center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        if granted {
          print("Разрешение на отправку уведомлений разрешено!")
        } else {
          print("В Разрешении на отправку уведомлений отказано.")
        }
      }
      
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }

}

