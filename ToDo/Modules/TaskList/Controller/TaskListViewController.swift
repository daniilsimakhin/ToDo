//
//  TaskListViewController.swift
//  ToDo
//
//  Created by Даниил Симахин on 11.08.2022.
//

import UIKit

final class TaskListViewController: UIViewController {
    
    var fileCache = FileCache()
    var numberCompletedTasks = 0
    var completedTasksHidden = false
    
    private var tableView = UITableView()
    
    private let addTaskButton: UIButton = {
        let addTaskButton = UIButton()
        addTaskButton.backgroundColor = Constans.Colors.navBarTaskColor
        addTaskButton.tintColor = .white
        
        let font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        let config = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        addTaskButton.setImage(image, for: .normal)
        
        addTaskButton.layer.cornerRadius = 25
        addTaskButton.layer.shadowColor = UIColor.black.cgColor
        addTaskButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        addTaskButton.layer.shadowRadius = 5
        addTaskButton.layer.shadowOpacity = 0.4
        addTaskButton.layer.masksToBounds = false
        
        addTaskButton.addTarget(self, action: #selector(addTaskButtonPressed), for: .touchUpInside)
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        return addTaskButton
    }()
    //MARK: - ViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        fileCache.loadTasks()
        createTableView()
        setupUI()
        addObservers()
    }
    
    deinit {
        removeObservers()
    }
    //MARK: - Private functions
    private func setupUI() {
        title = Constans.Texts.titleTaskList
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = Constans.Colors.backgroundColor
        
        view.addSubview(tableView)
        view.addSubview(addTaskButton)
        
        NSLayoutConstraint.activate([
            addTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTaskButton.heightAnchor.constraint(equalToConstant: 50),
            addTaskButton.widthAnchor.constraint(equalToConstant: 50),
            addTaskButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25)
        ])
    }
    
    private func createTableView() {
        tableView = UITableView(frame: view.frame, style: .insetGrouped)
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifire)
        tableView.register(TaskTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: TaskTableViewHeaderFooterView.identifire)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Constans.Colors.backgroundColor
    }
    
    private func swipeDeleteAction(task: Task, indexPath: IndexPath) {
        fileCache.loadTasks()
        fileCache.deleteTask(id: task.id)
        fileCache.saveTasks()
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }
    
    private func swipeDoneAction(task: Task, indexPath: IndexPath) {
        fileCache.loadTasks()
        for (index, value) in fileCache.toDoTasks.enumerated() {
            if value.id == task.id {
                fileCache.toDoTasks[index].isComplete = !task.isComplete
                fileCache.saveTasks()
            }
        }
        tableView.reloadData()
    }
    //MARK: - @objc functions
    @objc func addTaskButtonPressed(sender: UIButton!) {
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
    func deleteCurrentTask(id: String) {
        fileCache.loadTasks()
        fileCache.deleteTask(id: id)
        fileCache.saveTasks()
        tableView.reloadData()
    }
    
    func saveNewTask(newTask: Task) {
        fileCache.loadTasks()
        fileCache.addNewTask(task: newTask)
        if newTask.deadline != nil {
            NotificationService.shared.scheduleNotification(newTask)
        }
        fileCache.saveTasks()
        tableView.reloadData()
    }
    
    func saveChangedTask(oldTask: Task, newTask: Task, indexPath: IndexPath) {
        fileCache.loadTasks()
        fileCache.deleteTask(id: oldTask.id)
        if oldTask.importance == newTask.importance {
            fileCache.addNewTask(task: newTask, indexPath: indexPath)
        } else {
            fileCache.addNewTask(task: newTask)
        }
        if !newTask.isComplete && newTask.deadline != nil {
            NotificationService.shared.scheduleNotification(newTask)
        }
        fileCache.saveTasks()
        tableView.reloadData()
    }
}

//MARK: - TaskTableViewCellDelegate
extension TaskListViewController: TaskTableViewCellDelegate {
    func updateCell(check: Bool, task: Task) {
        fileCache.loadTasks()
        for (index, value) in fileCache.toDoTasks.enumerated() {
            if value.id == task.id {
                fileCache.toDoTasks[index].isComplete = check
                fileCache.saveTasks()
            }
        }
        if let deadline = task.deadline {
            if check {
                NotificationService.shared.removeScheduledNotification(task)
            } else {
                if deadline > Date() {
                    NotificationService.shared.scheduleNotification(task)
                }
            }
        }
        tableView.reloadData()
    }
}
//MARK: - TaskTableViewHeaderFooterViewDelegate
extension TaskListViewController: TaskTableViewHeaderFooterViewDelegate {
    func showButton(_ check: Bool) {
        completedTasksHidden = check
        tableView.reloadData()
    }
}
//MARK: - UITableViewDataSource
extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fileCache.loadTasks()
        if completedTasksHidden {
            var indexies = [String]()
            for task in fileCache.toDoTasks {
                if task.isComplete {
                    indexies.append(task.id)
                }
            }
            for index in indexies {
                fileCache.deleteTask(id: index)
            }
            numberCompletedTasks = indexies.count
            return fileCache.toDoTasks.count
        } else {
            numberCompletedTasks = fileCache.toDoTasks.reduce(0) { $1.isComplete ? $0 + 1 : $0 + 0 }
            return fileCache.toDoTasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifire, for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        let task = fileCache.toDoTasks[indexPath.row]
        cell.delegate = self
        cell.configure(task: task)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}
//MARK: - UITableViewDelegate
extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TaskTableViewHeaderFooterView.identifire) as? TaskTableViewHeaderFooterView else { return UIView() }
            headerView.configure(compeletedTask: numberCompletedTasks, isHidden: completedTasksHidden)
            headerView.delegate = self
            return headerView
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = fileCache.toDoTasks[indexPath.row]
        let addingVC = AddingTaskViewController()
        addingVC.delegate = self
        addingVC.configure(task: task, indexPath: indexPath)
        let navVc = UINavigationController(rootViewController: addingVC)
        navVc.modalPresentationStyle = .formSheet
        present(navVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, completionHandler) in
            
            let task = self.fileCache.toDoTasks[indexPath.row]
            self.swipeDeleteAction(task: task, indexPath: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "Done") {
            (action, sourceView, completionHandler) in
            
            let task = self.fileCache.toDoTasks[indexPath.row]
            self.swipeDoneAction(task: task, indexPath: indexPath)
            completionHandler(true)
        }
        doneAction.backgroundColor = Constans.Colors.checkboxColor
        doneAction.image = UIImage(systemName: "checkmark.circle.fill")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [doneAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = true
        return swipeConfiguration
    }
}
//MARK: - DidBecomeActiveNotification
extension TaskListViewController {
    fileprivate func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc fileprivate func applicationDidBecomeActive() {
        tableView.reloadData()
    }
}
