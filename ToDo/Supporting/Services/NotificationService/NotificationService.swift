//
//  NotificationService.swift
//  ToDo
//
//  Created by Даниил Симахин on 30.08.2022.
//

import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    var settings: UNNotificationSettings?
    let notificationCenter = UNUserNotificationCenter.current()
    
    private init () { }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            completion(granted)
            self.fetchNotificationSettings()
        }
    }
    
    func fetchNotificationSettings () {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue .main.async {
                self.settings = settings
            }
        }
    }
    
    func scheduleNotification(_ task: TaskModel) {
        let content = UNMutableNotificationContent()
        content.title = "ToDo"
        content.body = task.text
        
        content.categoryIdentifier = "ToDoCategory"
        let taskData = try? JSONEncoder().encode(task)
        if let taskData = taskData {
            content.userInfo = ["Task": taskData]
        }
        
        var trigger: UNNotificationTrigger?
        
        if let deadline = task.deadline?.timeIntervalSinceNow {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: deadline, repeats: false)
        }
        
        if let trigger = trigger {
            let request = UNNotificationRequest(
                identifier: task.id,
                content: content,
                trigger: trigger)
            
            notificationCenter.add(request) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    func removeScheduledNotification(_ task: TaskModel) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id])
    }
}
