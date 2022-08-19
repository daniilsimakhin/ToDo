//
//  TaskHeaderView.swift
//  ToDo
//
//  Created by Даниил Симахин on 18.08.2022.
//

import UIKit

protocol TaskHeaderViewDelegate {
    func showButton(_ completedTasksHidden: Bool)
}

class TaskHeaderView: UITableViewHeaderFooterView {
    
    var delegate: TaskHeaderViewDelegate?
    
    var completedTaskCount = 0 {
        didSet {
            title.text = "Выполнено - \(completedTaskCount)"
        }
    }
    
    var compeletedTasksHidden = false

    private let title: UILabel = {
        let title = UILabel()
        title.text = "Выполнено - 0"
        title.textColor = Constans.Colors.secondaryTextColor
        title.textAlignment = .left
        title.font = .systemFont(ofSize: 15, weight: .regular)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    private let showButton: UIButton = {
        let showButton = UIButton()
        showButton.setTitle("Показать", for: .normal)
        showButton.setTitleColor(Constans.Colors.navBarItemColor, for: .normal)
        showButton.contentHorizontalAlignment = .right
        showButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
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
    
    func setupUI() {
        self.addSubview(showButton)
        self.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            title.trailingAnchor.constraint(equalTo: showButton.leadingAnchor),
            title.heightAnchor.constraint(equalTo: showButton.heightAnchor),
            
            showButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            showButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            showButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func configure(compeletedTask: Int, isHidden: Bool) {
        title.text = "Выполнено - \(compeletedTask)"
        completedTaskCount = compeletedTask
        setTasksHidden(state: isHidden)
    }
    
    @objc func showButtonPressed(sender: UIButton!) {
        setTasksHidden(state: !compeletedTasksHidden)
    }
    
    func setTasksHidden(state: Bool) {
        compeletedTasksHidden = state
        delegate?.showButton(compeletedTasksHidden)
        if compeletedTasksHidden {
            showButton.setTitle("Показать", for: .normal)
        } else {
            showButton.setTitle("Cкрыть", for: .normal)
        }
    }
}
