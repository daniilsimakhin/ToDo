//
//  ViewController.swift
//  ToDo
//
//  Created by Даниил Симахин on 11.08.2022.
//

import UIKit

final class ItemListViewController: UIViewController {
    
    var fileCache = FileCache()
    var numberCompletedTasks = 0
    var completedTasksHidden = false
    
    private var tableView = UITableView()
    
    private let addTaskButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constans.Colors.navBarItemColor
        button.tintColor = .white
        
        let font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        let config = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        button.setImage(image, for: .normal)
        
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.4
        button.layer.masksToBounds = false
        
        button.addTarget(self, action: #selector(addTaskButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
//MARK: - ViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        fileCache.loadItems()
        createTableView()
        setupUI()
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
    
    private func swipeDeleteAction(item: ToDoItem, indexPath: IndexPath) {
        fileCache.loadItems()
        fileCache.deleteItem(id: item.id)
        fileCache.saveItems()
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }
    
    private func swipeDoneAction(item: ToDoItem, indexPath: IndexPath) {
        fileCache.loadItems()
        for (index, value) in fileCache.toDoItems.enumerated() {
            if value.id == item.id {
                fileCache.toDoItems[index].isComplete = !item.isComplete
                fileCache.saveItems()
            }
        }
        tableView.reloadData()
    }
//MARK: - @objc functions
    @objc func addTaskButtonPressed(sender: UIButton!) {
        let addingVC = AddingTaskViewController()
        addingVC.delegate = self
        addingVC.configure(item: nil, indexPath: nil)
        let navVc = UINavigationController(rootViewController: addingVC)
        navVc.modalPresentationStyle = .formSheet
        present(navVc, animated: true)
    }
}
//MARK: - AddingTaskViewControllerDelegate
extension ItemListViewController: AddingTaskViewControllerDelegate {
    func deleteCurrentItem(id: String) {
        fileCache.loadItems()
        fileCache.deleteItem(id: id)
        fileCache.saveItems()
        tableView.reloadData()
    }
    
    func saveNewItem(newItem: ToDoItem) {
        fileCache.loadItems()
        fileCache.addNewItem(item: newItem)
        fileCache.saveItems()
        tableView.reloadData()
    }
    
    func saveChangedItem(oldItem: ToDoItem, newItem: ToDoItem, indexPath: IndexPath) {
        fileCache.loadItems()
        fileCache.deleteItem(id: oldItem.id)
        if oldItem.importance == newItem.importance {
            fileCache.addNewItem(item: newItem, indexPath: indexPath)
        } else {
            fileCache.addNewItem(item: newItem)            
        }
        fileCache.saveItems()
        tableView.reloadData()
    }
}

//MARK: - TaskTableViewCellDelegate
extension ItemListViewController: TaskTableViewCellDelegate {
    func updateCell(check: Bool, item: ToDoItem) {
        fileCache.loadItems()
        for (index, value) in fileCache.toDoItems.enumerated() {
            if value.id == item.id {
                fileCache.toDoItems[index].isComplete = check
                fileCache.saveItems()
            }
        }
        tableView.reloadData()
    }
}
//MARK: - TaskHeaderViewDelegate
extension ItemListViewController: TaskTableViewHeaderFooterViewDelegate {
    func showButton(_ check: Bool) {
        completedTasksHidden = check
        tableView.reloadData()
    }
}
//MARK: - UITableViewDataSource
extension ItemListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fileCache.loadItems()
        if completedTasksHidden {
            var indexies = [String]()
            for item in fileCache.toDoItems {
                if item.isComplete {
                    indexies.append(item.id)
                }
            }
            for index in indexies {
                fileCache.deleteItem(id: index)
            }
            numberCompletedTasks = indexies.count
            return fileCache.toDoItems.count
        } else {
            numberCompletedTasks = fileCache.toDoItems.reduce(0) { $1.isComplete ? $0 + 1 : $0 + 0 }
            return fileCache.toDoItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifire, for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        let item = fileCache.toDoItems[indexPath.row]
        cell.delegate = self
        cell.configure(item: item)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}
//MARK: - UITableViewDelegate
extension ItemListViewController: UITableViewDelegate {
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
        let item = fileCache.toDoItems[indexPath.row]
        let addingVC = AddingTaskViewController()
        addingVC.delegate = self
        addingVC.configure(item: item, indexPath: indexPath)
        let navVc = UINavigationController(rootViewController: addingVC)
        navVc.modalPresentationStyle = .formSheet
        present(navVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, completionHandler) in
            
            let item = self.fileCache.toDoItems[indexPath.row]
            self.swipeDeleteAction(item: item, indexPath: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "Done") {
            (action, sourceView, completionHandler) in
            
            let item = self.fileCache.toDoItems[indexPath.row]
            self.swipeDoneAction(item: item, indexPath: indexPath)
            completionHandler(true)
        }
        doneAction.backgroundColor = Constans.Colors.checkboxColor
        doneAction.image = UIImage(systemName: "checkmark.circle.fill")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [doneAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = true
        return swipeConfiguration
    }
}
