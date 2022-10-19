//
//  AppDelegate.swift
//  ToDo
//
//  Created by Даниил Симахин on 11.08.2022.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureUserNotifications()
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    private func configureUserNotifications() {
        UNUserNotificationCenter.current().delegate = self
        
        let markAsDone = UNNotificationAction(
          identifier: "markAsDone",
          title: "Выполнено",
          options: [])
        
        let category = UNNotificationCategory(
          identifier: "ToDoCategory",
          actions: [markAsDone],
          intentIdentifiers: [],
          options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "markAsDone" {
            let userInfo = response.notification.request.content.userInfo
            if let item = ToDoItem.parse(json: userInfo["Item"] as! NSMutableDictionary) {
                let fileCache = FileCache()
                fileCache.loadItems()
                if let index = fileCache.toDoItems.firstIndex(where: { $0.id == item.id }) {
                    fileCache.deleteItem(id: item.id)
                    fileCache.addNewItem(item: ToDoItem(id: item.id, text: item.text, importance: item.importance, deadline: item.deadline, isComplete: !item.isComplete, dateCreated: item.dateCreated, dateChanged: Date()), indexPath: IndexPath(row: index, section: 0))
                    fileCache.saveItems()
                }
            }
        }
        completionHandler()
    }
}
