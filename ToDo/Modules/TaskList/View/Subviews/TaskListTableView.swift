//
//  TaskListTableView.swift
//  ToDo
//
//  Created by Даниил Симахин on 21.10.2022.
//

import UIKit

protocol TaskListTableViewActionDelegate {
    func updateCell(isComplete: Bool, task: Task)
    func setVisibilityCompletedTasks(_ isCompleteTasksHidden: Bool)
    func swipeDeleteAction(_ indexPath: IndexPath)
    func swipeDoneAction(_ indexPath: IndexPath)
    func didSelectRowAt(_ indexPath: IndexPath)
}

protocol TaskListTableViewDataSourceDelegate {
    func taskListTableView(_ tableView: TaskListTableView, numberOfRowsInSection section: Int) -> Int
    func taskListTableView(_ tableView: TaskListTableView, cellForRowAt indexPath: IndexPath) -> Task
    func numberOfSections(in tableView: TaskListTableView) -> Int
    func numberOfCompletedTasks() -> Int
}

class TaskListTableView: UITableView {
    
    var actionDelegate: TaskListTableViewActionDelegate!
    var dataSourceDelegate: TaskListTableViewDataSourceDelegate!
    
    var isCompleteTasksHidden = true
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TaskListTableView {
    func setup() {
        register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifire)
        register(TaskTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: TaskTableViewHeaderFooterView.identifire)
        delegate = self
        dataSource = self
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 70
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Constans.Colors.backgroundColor
    }
}

//MARK: - UITableViewDataSource

extension TaskListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceDelegate.numberOfSections(in: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifire, for: indexPath) as? TaskTableViewCell else { fatalError("Cannot create cell with type - \(TaskTableViewCell.self)") }
        let task = dataSourceDelegate.taskListTableView(self, cellForRowAt: indexPath)
        cell.delegate = self
        cell.configure(task: task)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dataSourceDelegate.numberOfSections(in: self)
    }
}

//MARK: - UITableViewDelegate

extension TaskListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TaskTableViewHeaderFooterView.identifire) as? TaskTableViewHeaderFooterView else { fatalError("Cannot create cell with type - \(TaskTableViewHeaderFooterView.self)") }
            headerView.configure(compeletedTask: dataSourceDelegate.numberOfCompletedTasks(), isHidden: isCompleteTasksHidden)
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
        actionDelegate.didSelectRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            [weak self] (action, sourceView, completionHandler) in
            
            self?.actionDelegate.swipeDeleteAction(indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "Done") {
            [weak self] (action, sourceView, completionHandler) in
            
            self?.actionDelegate.swipeDoneAction(indexPath)
            completionHandler(true)
        }
        doneAction.backgroundColor = Constans.Colors.checkboxColor
        doneAction.image = UIImage(systemName: "checkmark.circle.fill")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [doneAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = true
        return swipeConfiguration
    }
}

//MARK: - TaskTableViewCellDelegate

extension TaskListTableView: TaskTableViewCellDelegate {
    func updateCell(check: Bool, task: Task) {
        actionDelegate.updateCell(isComplete: check, task: task)
    }
}

//MARK: - TaskTableViewHeaderFooterViewDelegate

extension TaskListTableView: TaskTableViewHeaderFooterViewDelegate {
    func showButton(_ check: Bool) {
        actionDelegate.setVisibilityCompletedTasks(check)
    }
}
