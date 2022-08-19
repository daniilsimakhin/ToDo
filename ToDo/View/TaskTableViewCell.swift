//
//  TaskTableViewCell.swift
//  ToDo
//
//  Created by Даниил Симахин on 17.08.2022.
//

import UIKit

protocol TaskTableViewCellDelegate {
    func updateCell (check: Bool, item: ToDoItem)
}

class TaskTableViewCell: UITableViewCell {
    
    var delegate: TaskTableViewCellDelegate?
    static var identifire = "TaskTableViewCell"
    var state = false
    var callback: ((Bool) -> ())?
    var item: ToDoItem?
    
    private var checkbox: UIButton = {
        let checkbox = UIButton()
        checkbox.tintColor = Constans.Colors.secondaryTextColor
        checkbox.addTarget(self,
                           action: #selector(checkboxPressedButton),
                           for: .touchUpInside)
        let font = UIFont.systemFont(ofSize: 30, weight: .medium)
        let config = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "circle", withConfiguration: config)
        checkbox.setImage(image, for: .normal)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let title: UILabel = {
        let text = UILabel()
        text.text = String()
        text.textColor = Constans.Colors.textColor
        text.numberOfLines = 3
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private let dateTitle: UILabel = {
        let date = UILabel()
        date.text = String()
        date.textColor = Constans.Colors.secondaryTextColor
        date.isHidden = true
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func checkboxPressedButton(sender: UIButton!) {
        changeStateCheckbox(!state)
    }
    
    func configure(item: ToDoItem) {
        self.item = item
        title.text = item.text
        changeStateCheckbox(item.isComplete)
        
        if let deadline = item.deadline {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd MMMM"
            
            let date: NSDate? = dateFormatterGet.date(from: dateFormatterGet.string(from: deadline)) as NSDate?
            
            dateTitle.isHidden = false
            dateTitle.text = dateFormatterPrint.string(from: date! as Date)
        } else {
            dateTitle.isHidden = true
            dateTitle.text = nil
        }
    }
    
    func changeStateCheckbox(_ check: Bool) {
        state = check
        delegate?.updateCell(check: state, item: item!)
        let font = UIFont.systemFont(ofSize: 30, weight: .medium)
        let config = UIImage.SymbolConfiguration(font: font)
        
        if state {
            let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
            checkbox.setImage(image, for: .normal)
            checkbox.tintColor = Constans.Colors.checkboxColor
            
            let attributeString = NSMutableAttributedString(string: title.text!)
            attributeString.addAttribute(
                NSAttributedString.Key.strikethroughStyle,
                value: 1,
                range: NSRange(location: 0, length: attributeString.length))
            title.attributedText = attributeString
            title.textColor = Constans.Colors.secondaryTextColor
        } else {
            let image = UIImage(systemName: "circle", withConfiguration: config)
            checkbox.setImage(image, for: .normal)
            checkbox.tintColor = Constans.Colors.secondaryTextColor
            
            let attributeString = NSMutableAttributedString(string: title.text!)
            attributeString.addAttribute(
                NSAttributedString.Key.strikethroughStyle,
                value: 0,
                range: NSRange(location: 0, length: attributeString.length))
            title.attributedText = attributeString
            title.textColor = Constans.Colors.textColor
        }
    }
    
    private func setupUI() {
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(checkbox)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(dateTitle)
        
        NSLayoutConstraint.activate([
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            checkbox.heightAnchor.constraint(equalToConstant: 25),
            checkbox.widthAnchor.constraint(equalToConstant: 25),

            stackView.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 10),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            contentView.topAnchor.constraint(lessThanOrEqualTo: stackView.topAnchor, constant: 15),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: 15)
        ])
    }
}
