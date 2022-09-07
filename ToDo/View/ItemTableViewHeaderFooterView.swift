//
//  TaskHeaderView.swift
//  ToDo
//
//  Created by Даниил Симахин on 18.08.2022.
//

import UIKit

protocol TaskTableViewHeaderFooterViewDelegate {
    func showButton(_ check: Bool)
}

class ItemTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    static let identifire = "TaskTableViewHeaderFooterView"
    
    var delegate: TaskTableViewHeaderFooterViewDelegate?
    
    var completedTaskCount = 0 {
        didSet {
            title.text = "Выполнено - \(completedTaskCount)"
        }
    }
    
    var compeletedTasksHidden = false

    private let title: UILabel = {
        let title = UILabel()
        title.text = "Выполнено - $"
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
    
    private func setupUI() {
        contentView.addSubview(showButton)
        contentView.addSubview(title)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//            title.trailingAnchor.constraint(equalTo: showButton.leadingAnchor, constant: -10),
            title.heightAnchor.constraint(equalTo: showButton.heightAnchor),
            
            showButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            //showButton.widthAnchor.constraint(equalToConstant: 80),
            showButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            showButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func setTasksHidden(state: Bool) {
        compeletedTasksHidden = state
        if compeletedTasksHidden {
            showButton.setTitle("Показать", for: .normal)
        } else {
            showButton.setTitle("Cкрыть", for: .normal)
        }
    }
    
    func configure(compeletedTask: Int, isHidden: Bool) {
        title.text = "Выполнено - \(compeletedTask)"
        completedTaskCount = compeletedTask
        setTasksHidden(state: isHidden)
    }
    
    @objc func showButtonPressed(sender: UIButton!) {
        setTasksHidden(state: !compeletedTasksHidden)
        delegate?.showButton(compeletedTasksHidden)
    }
}
