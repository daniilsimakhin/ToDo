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
            let taskService = TaskService()
            taskService.loadTasks()
            if let taskData = userInfo["Task"] as? Data,
               let task = try? JSONDecoder().decode(TaskModel.self, from: taskData),
               let index = taskService.tasks.firstIndex(where: { $0.id == task.id }) {
                taskService.deleteTask(id: task.id)
                taskService.appendTask(task: TaskModel(id: task.id, text: task.text, importance: task.importance, deadline: task.deadline, isComplete: !task.isComplete, dateCreated: task.dateCreated, dateChanged: Date()), indexPath: IndexPath(row: index, section: 0))
                taskService.saveTasks()
            }
        }
        completionHandler()
    }
}
