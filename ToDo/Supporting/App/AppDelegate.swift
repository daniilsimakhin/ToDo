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
            if let task = Task.parse(json: userInfo["Task"] as! NSMutableDictionary) {
                let fileCache = FileCache()
                fileCache.loadTasks()
                if let index = fileCache.toDoTasks.firstIndex(where: { $0.id == task.id }) {
                    fileCache.deleteTask(id: task.id)
                    fileCache.addNewTask(task: Task(id: task.id, text: task.text, importance: task.importance, deadline: task.deadline, isComplete: !task.isComplete, dateCreated: task.dateCreated, dateChanged: Date()), indexPath: IndexPath(row: index, section: 0))
                    fileCache.saveTasks()
                }
            }
        }
        completionHandler()
    }
}
