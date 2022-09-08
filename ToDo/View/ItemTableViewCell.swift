//
//  ItemTableViewCell.swift
//  ToDo
//
//  Created by Даниил Симахин on 17.08.2022.
//

import UIKit

protocol ItemTableViewCellDelegate {
    func updateCell (check: Bool, item: ToDoItem)
}

class ItemTableViewCell: UITableViewCell {
    
    var delegate: ItemTableViewCellDelegate?
    static var identifire = "ItemTableViewCellDelegate"
    var state = false
    var item: ToDoItem?

    private var checkbox: UIButton = {
        let checkbox = UIButton()
        checkbox.tintColor = Constans.Colors.secondaryTextColor
        checkbox.addTarget(self,
                           action: #selector(checkboxPressedButton),
                           for: .touchUpInside)
        let font = UIFont.systemFont(ofSize: 20)
        let config = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "circle", withConfiguration: config)
        checkbox.setImage(image, for: .normal)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let title: UILabel = {
        let title = UILabel()
        title.text = String()
        title.textColor = Constans.Colors.textColor
        title.numberOfLines = 3
        return title
    }()
    private let dateStackView: UIStackView = {
        let dateStackView = UIStackView()
        dateStackView.axis = .horizontal
        dateStackView.alignment = .leading
        dateStackView.distribution = .fill
        dateStackView.spacing = 2
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        dateStackView.isHidden = true
        return dateStackView
    }()
    private let dateImage: UIImageView = {
        let dateImage = UIImageView()
        let font = UIFont.systemFont(ofSize: 15)
        let config = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "calendar", withConfiguration: config)
        dateImage.image = image
        dateImage.tintColor = Constans.Colors.secondaryTextColor
        return dateImage
    }()
    private let dateTitle: UILabel = {
        let dateTitle = UILabel()
        dateTitle.text = String()
        dateTitle.font = .systemFont(ofSize: 15)
        dateTitle.textColor = Constans.Colors.secondaryTextColor
        return dateTitle
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
        delegate?.updateCell(check: state, item: item!)
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
            
            dateStackView.isHidden = false
            dateTitle.text = dateFormatterPrint.string(from: date! as Date)
        } else {
            dateStackView.isHidden = true
            dateTitle.text = nil
        }
        
        switch item.importance {
        case .unimportant:
            title.text = "↓" + title.text!
            break
        case .ordinary:
            break
        case .important:
            title.text = "‼️" + title.text!
            break
        }
    }
    
    func changeStateCheckbox(_ check: Bool) {
        state = check
        let font = UIFont.systemFont(ofSize: 20)
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
        self.backgroundColor = Constans.Colors.mainViewColor
    
        contentView.addSubview(checkbox)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(dateStackView)
        dateStackView.addArrangedSubview(dateImage)
        dateStackView.addArrangedSubview(dateTitle)
        
        NSLayoutConstraint.activate([
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

            stackView.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
}
