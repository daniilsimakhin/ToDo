import UIKit

protocol TaskListTableViewActionDelegate: AnyObject {
    func setCompletedTask(isComplete: Bool, task: TaskModel)
    func setVisibilityCompletedTasks(_ isCompleteTasksHidden: Bool)
    func swipeDeleteAction(_ indexPath: IndexPath)
    func swipeDoneAction(_ indexPath: IndexPath)
    func didSelectRowAt(_ indexPath: IndexPath)
}

protocol TaskListTableViewDataSourceDelegate: AnyObject {
    func taskListTableView(numberOfRowsInSection section: Int) -> Int
    func taskListTableView(cellForRowAt indexPath: IndexPath) -> TaskModel
    func numberOfSections() -> Int
    func numberOfCompletedTasks() -> Int
    func getCompletedTasksHidden() -> Bool
}

class TaskListTableView: UITableView {
    
    var actionDelegate: TaskListTableViewActionDelegate!
    var dataSourceDelegate: TaskListTableViewDataSourceDelegate!
    
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
        backgroundColor = Constans.Colors.backgroundColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - UITableViewDataSource

extension TaskListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceDelegate.taskListTableView(numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifire, for: indexPath) as? TaskTableViewCell else { fatalError("Cannot create cell with type - \(TaskTableViewCell.self)") }
        let task = dataSourceDelegate.taskListTableView(cellForRowAt: indexPath)
        cell.delegate = self
        cell.configure(task: task)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSourceDelegate.numberOfSections()
    }
}

// MARK: - UITableViewDelegate

extension TaskListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TaskTableViewHeaderFooterView.identifire) as? TaskTableViewHeaderFooterView else { fatalError("Cannot create cell with type - \(TaskTableViewHeaderFooterView.self)") }
            headerView.configure(compeletedTask: dataSourceDelegate.numberOfCompletedTasks(), isHidden: dataSourceDelegate.getCompletedTasksHidden())
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
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            
            self?.actionDelegate.swipeDeleteAction(indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "Done") { [weak self] _, _, completionHandler in
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

// MARK: - TaskTableViewCellDelegate

extension TaskListTableView: TaskTableViewCellDelegate {
    func setStateTask(state: Bool, task: TaskModel) {
        actionDelegate.setCompletedTask(isComplete: state, task: task)
    }
}

// MARK: - TaskTableViewHeaderFooterViewDelegate

extension TaskListTableView: TaskTableViewHeaderFooterViewDelegate {
    func setStateShowTask(_ state: Bool) {
        actionDelegate.setVisibilityCompletedTasks(state)
    }
}
