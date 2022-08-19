//
//  ViewController.swift
//  ToDo
//
//  Created by Даниил Симахин on 11.08.2022.
//

import UIKit

class TaskList: UIViewController {
    
    var fileCache = FileCache()
    
    private var tableView = UITableView()
    
    private let addTaskButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fileCache.loadItems()
        createTableView()
        setupUI()
    }
    
    func setupUI() {
        title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .tertiarySystemGroupedBackground
        
        view.addSubview(tableView)
        view.addSubview(addTaskButton)
        
        NSLayoutConstraint.activate([
            addTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTaskButton.heightAnchor.constraint(equalToConstant: 50),
            addTaskButton.widthAnchor.constraint(equalToConstant: 50),
            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func createTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifire)
        tableView.register(TaskHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .tertiarySystemGroupedBackground
        tableView.allowsSelection = false
    }
    
    @objc func addTaskButtonPressed(sender: UIButton!) {
        let addingVC = AddingTaskViewController()
        present(addingVC, animated: true)
    }
    
    func swipeDeleteAction(item: ToDoItem, indexPath: IndexPath) {
        fileCache.deleteItem(id: item.id)
        fileCache.saveItems()
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
//MARK: - TaskTableViewCellDelegate
extension TaskList: TaskTableViewCellDelegate {
    func updateCell(check: Bool, item: ToDoItem) {
        for (index, value) in fileCache.toDoItems.enumerated() {
            if value.id == item.id {
                fileCache.toDoItems[index].isComplete = check
                fileCache.saveItems()
            }
        }
        guard let header = tableView.headerView(forSection: 0) as? TaskHeaderView else { return }
        let completedTask = fileCache.toDoItems.filter { item in
            item.isComplete == true
        }
        header.configure(compeletedTask: completedTask.count, isHidden: header.compeletedTasksHidden)
    }
}
//MARK: - TaskHeaderViewDelegate
extension TaskList: TaskHeaderViewDelegate {
    func showButton(_ completedTasksHidden: Bool) {
    }
}
//MARK: - UITableViewDataSource
extension TaskList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileCache.toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifire, for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
            let item = fileCache.toDoItems[indexPath.row]
            cell.configure(item: item)
            cell.delegate = self
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}
//MARK: - UITableViewDelegate
extension TaskList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? TaskHeaderView else { return UIView() }
            let completedTask = fileCache.toDoItems.filter { item in
                item.isComplete == true
            }
            headerView.configure(compeletedTask: completedTask.count, isHidden: false)
            return headerView
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        guard let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell else { return }
        //        fileCache.deleteItem(id: cell.item?.id ?? "")
        //        fileCache.saveItems()
        //        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, completionHandler) in
            
            let item = self.fileCache.toDoItems[indexPath.row]
            self.swipeDeleteAction(item: item, indexPath: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.title = "Delete"
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        //swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
}
