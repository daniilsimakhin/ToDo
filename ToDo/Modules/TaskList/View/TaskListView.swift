import UIKit

protocol TaskListViewInput: AnyObject {
    func reloadTable()
    func reloadRows(_ indexPath: [IndexPath])
    func deleteRows(_ indexPath: [IndexPath])
}

protocol TaskListViewDelegate: AnyObject {
    func appendTask()
    func numberOfRowsInSection(_ section: Int) -> Int
    func cellForRowAt(_ indexPath: IndexPath) -> TaskModel
    func numberOfSections() -> Int
    func numberOfCompletedTasks() -> Int
    func getCompletedTasksHidden() -> Bool
    
    func setCompletedTask(_ isComplete: Bool, _ task: TaskModel)
    func setVisibilityCompletedTasks(_ isCompleteTasksHidden: Bool)
    func swipeDeleteAction(_ indexPath: IndexPath)
    func swipeDoneAction(_ indexPath: IndexPath)
    func didSelectRowAt(_ indexPath: IndexPath)
}

class TaskListView: UIView {
    
    var delegate: TaskListViewDelegate!
    
    private lazy var taskListTableView: TaskListTableView = {
        let tableview = TaskListTableView(frame: frame, style: .insetGrouped)
        tableview.actionDelegate = self
        tableview.dataSourceDelegate = self
        return tableview
    }()
    private lazy var appendTaskButton: AppendTaskButton = {
        let button = AppendTaskButton()
        button.addTarget(self, action: #selector(appendTaskButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addObservers()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObservers()
    }
}

// MARK: - Private func

private extension TaskListView {
    func setup() {
        backgroundColor = Constans.Colors.backgroundColor
        
        addSubview(taskListTableView)
        NSLayoutConstraint.activate([
            taskListTableView.topAnchor.constraint(equalTo: topAnchor),
            taskListTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            taskListTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            taskListTableView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        addSubview(appendTaskButton)
        NSLayoutConstraint.activate([
            appendTaskButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            appendTaskButton.heightAnchor.constraint(equalToConstant: 50),
            appendTaskButton.widthAnchor.constraint(equalToConstant: 50),
            appendTaskButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25)
        ])
    }
}

// MARK: - @objc private func

@objc private extension TaskListView {
    func appendTaskButtonPressed() {
        delegate.appendTask()
    }
}

// MARK: - TaskListTableViewActionDelegate

extension TaskListView: TaskListTableViewActionDelegate {
    func setCompletedTask(isComplete: Bool, task: TaskModel) {
        delegate.setCompletedTask(isComplete, task)
    }
    
    func setVisibilityCompletedTasks(_ isCompleteTasksHidden: Bool) {
        delegate.setVisibilityCompletedTasks(isCompleteTasksHidden)
        taskListTableView.reloadData()
    }
    
    func swipeDeleteAction(_ indexPath: IndexPath) {
        delegate.swipeDeleteAction(indexPath)
        taskListTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func swipeDoneAction(_ indexPath: IndexPath) {
        delegate.swipeDoneAction(indexPath)
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        taskListTableView.deselectRow(at: indexPath, animated: true)
        delegate.didSelectRowAt(indexPath)
    }
}

// MARK: - TaskListTableViewDataSourceDelegate

extension TaskListView: TaskListTableViewDataSourceDelegate {
    func getCompletedTasksHidden() -> Bool {
        return delegate.getCompletedTasksHidden()
    }
    
    func taskListTableView(numberOfRowsInSection section: Int) -> Int {
        return delegate.numberOfRowsInSection(section)
    }
    
    func taskListTableView(cellForRowAt indexPath: IndexPath) -> TaskModel {
        return delegate.cellForRowAt(indexPath)
    }
    
    func numberOfSections() -> Int {
        return delegate.numberOfSections()
    }
    
    func numberOfCompletedTasks() -> Int {
        return delegate.numberOfCompletedTasks()
    }
}

// MARK: - DidBecomeActiveNotification

extension TaskListView {
    fileprivate func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc fileprivate func applicationDidBecomeActive() {
        taskListTableView.reloadData()
    }
}

extension TaskListView: TaskListViewInput {
    func deleteRows(_ indexPath: [IndexPath]) {
        taskListTableView.deleteRows(at: indexPath, with: .automatic)
    }
    
    func reloadRows(_ indexPath: [IndexPath]) {
        taskListTableView.reloadRows(at: indexPath, with: .automatic)
    }
    
    func reloadTable() {
        taskListTableView.reloadData()
    }
}
