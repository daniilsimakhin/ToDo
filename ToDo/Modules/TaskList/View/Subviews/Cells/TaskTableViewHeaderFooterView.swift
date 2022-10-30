//
//  TaskTableViewHeaderFooterView.swift
//  ToDo
//
//  Created by Даниил Симахин on 18.08.2022.
//

import UIKit

protocol TaskTableViewHeaderFooterViewDelegate: AnyObject {
    func setStateShowTask(_ state: Bool)
}

class TaskTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    static let identifire = String(describing: TaskTableViewHeaderFooterView.self)
    
    var delegate: TaskTableViewHeaderFooterViewDelegate!
    
    var completedTaskCount = 0 {
        didSet {
            numberOfTasksLabel.text = "Выполнено - \(completedTaskCount)"
        }
    }
    
    var compeletedTasksHidden = false {
        didSet {
            if compeletedTasksHidden {
                showButton.setTitle("Показать", for: .normal)
            } else {
                showButton.setTitle("Cкрыть", for: .normal)
            }
        }
    }

    private let numberOfTasksLabel: UILabel = {
        let title = UILabel()
        title.textColor = Constans.Colors.secondaryTextColor
        title.textAlignment = .left
        title.font = .caption
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    private lazy var showButton: UIButton = {
        let showButton = UIButton()
        showButton.setTitle("Показать", for: .normal)
        showButton.setTitleColor(Constans.Colors.navBarTaskColor, for: .normal)
        showButton.contentHorizontalAlignment = .right
        showButton.titleLabel?.font = .bold
        showButton.addTarget(self, action: #selector(showButtonPressed(sender:)), for: .touchUpInside)
        showButton.translatesAutoresizingMaskIntoConstraints = false
        return showButton
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(numberOfTasksLabel)
        NSLayoutConstraint.activate([
            numberOfTasksLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            numberOfTasksLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor)
            
        ])
        contentView.addSubview(showButton)
        NSLayoutConstraint.activate([
            showButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            showButton.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
    
    func configure(compeletedTask: Int, isHidden: Bool) {
        completedTaskCount = compeletedTask
        compeletedTasksHidden = isHidden
    }
    
    @objc func showButtonPressed(sender: UIButton!) {
        compeletedTasksHidden = !compeletedTasksHidden
        delegate.setStateShowTask(compeletedTasksHidden)
    }
}
