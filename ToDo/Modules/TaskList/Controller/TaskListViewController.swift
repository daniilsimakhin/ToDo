//
//  TaskListViewController.swift
//  ToDo
//
//  Created by Даниил Симахин on 11.08.2022.
//

import UIKit

class TaskListViewController: BaseViewController<TaskListView> {
    
    var taskListViewInput: TaskListViewInput!
    var taskService = TaskService()
    var numberCompletedTasks = 0
    var completedTasksHidden = false

    override func setup() {
        taskService.loadTasks()
        title = Constans.Texts.titleTaskList
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func setDelegates() {
        baseView.delegate = self
        taskListViewInput = baseView
    }
}

extension TaskListViewController: TaskListViewDelegate {
    func getCompletedTasksHidden() -> Bool {
        return completedTasksHidden
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        taskService.loadTasks()
        if completedTasksHidden {
            var indexies = [String]()
            for task in taskService.tasks {
                if task.isComplete {
                    indexies.append(task.id)
                }
            }
            for index in indexies {
                taskService.deleteTask(id: index)
            }
            numberCompletedTasks = indexies.count
            return taskService.tasks.count
        } else {
            numberCompletedTasks = taskService.tasks.reduce(0) { $1.isComplete ? $0 + 1 : $0 + 0 }
            return taskService.tasks.count
        }
    }
    
    func cellForRowAt(_ indexPath: IndexPath) -> TaskModel {
        return taskService.tasks[indexPath.row]
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfCompletedTasks() -> Int {
        return numberCompletedTasks
    }
    
    func setCompletedTask(_ isComplete: Bool, _ task: TaskModel) {
        taskService.replaceTask(task: task)
    }
    
    func setVisibilityCompletedTasks(_ isCompleteTasksHidden: Bool) {
        completedTasksHidden = isCompleteTasksHidden
    }
    
    func swipeDeleteAction(_ indexPath: IndexPath) {
        let task = taskService.tasks[indexPath.row]
        taskService.loadTasks()
        taskService.deleteTask(id: task.id)
        taskService.saveTasks()
    }
    
    func swipeDoneAction(_ indexPath: IndexPath) {
        taskService.replaceTask(indexPath: indexPath)
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        let task = taskService.tasks[indexPath.row]
        let addingVC = AddingTaskViewController()
        addingVC.delegate = self
        addingVC.configure(task: task, indexPath: indexPath)
        let navVc = UINavigationController(rootViewController: addingVC)
        navVc.modalPresentationStyle = .formSheet
        present(navVc, animated: true)
    }
    
    func appendTask() {
        let addingVC = AddingTaskViewController()
        addingVC.delegate = self
        addingVC.configure(task: nil, indexPath: nil)
        let navVc = UINavigationController(rootViewController: addingVC)
        navVc.modalPresentationStyle = .formSheet
        present(navVc, animated: true)
    }
}

//MARK: - AddingTaskViewControllerDelegate

extension TaskListViewController: AddingTaskViewControllerDelegate {
    func deleteCurrentTask(id: String, indexPath: IndexPath) {
        taskService.loadTasks()
        taskService.deleteTask(id: id)
        taskService.saveTasks()
        taskListViewInput.deleteRows([indexPath])
//        taskListViewInput.reloadTable()
    }
    
    func saveNewTask(newTask: TaskModel) {
        taskService.loadTasks()
        taskService.appendTask(task: newTask, indexPath: nil)
        if newTask.deadline != nil {
            NotificationService.shared.scheduleNotification(newTask)
        }
        taskService.saveTasks()
        taskListViewInput.reloadTable()
    }
    
    func saveChangedTask(oldTask: TaskModel, newTask: TaskModel, indexPath: IndexPath) {
        taskService.loadTasks()
        taskService.deleteTask(id: oldTask.id)
        if oldTask.importance == newTask.importance {
            taskService.appendTask(task: newTask, indexPath: indexPath)
        } else {
            taskService.appendTask(task: newTask, indexPath: nil)
        }
        if !newTask.isComplete && newTask.deadline != nil {
            NotificationService.shared.scheduleNotification(newTask)
        }
        taskService.saveTasks()
        taskListViewInput.reloadTable()
    }
}
