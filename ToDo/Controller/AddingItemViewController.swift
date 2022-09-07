//
//  AddingTaskViewController.swift
//  ToDo
//
//  Created by Даниил Симахин on 17.08.2022.
//

import UIKit

protocol AddingTaskViewControllerDelegate {
    func saveNewItem(newItem: ToDoItem)
    func saveChangedItem(oldItem: ToDoItem, newItem: ToDoItem, indexPath: IndexPath)
    func deleteCurrentItem(id: String)
}

final class AddingItemViewController: UIViewController {
    
    private var item: ToDoItem?
    private var indexPath: IndexPath?
    private var keyboardIsHidden = true
    var delegate: AddingTaskViewControllerDelegate?
    
    private var contentSize: CGSize {
        if keyboardIsHidden {
            return CGSize(width: view.frame.width, height: 80 + 112 + 56 + textView.frame.height)
        } else {
            return CGSize(width: view.frame.width, height: 80 + 112 + 56 + textView.frame.height + 346)
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }()
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.frame.size = contentSize
        return contentView
    }()
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = Constans.Colors.textColor
        textView.backgroundColor = Constans.Colors.mainViewColor
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.isScrollEnabled = false
        textView.sizeToFit()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = Constans.Colors.backgroundColor
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var importanceView: UIView = {
        let importanceView = UIView()
        importanceView.backgroundColor = Constans.Colors.mainViewColor
        importanceView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        importanceView.translatesAutoresizingMaskIntoConstraints = false
        return importanceView
    }()
    private lazy var importanceLabel: UILabel = {
        let importanceLabel = UILabel()
        importanceLabel.text = Constans.Texts.importance
        importanceLabel.translatesAutoresizingMaskIntoConstraints = false
        return importanceLabel
    }()
    private lazy var importanceSegmentedControl: UISegmentedControl = {
        let importanceSegmentedControl = UISegmentedControl(items: ["↓", "нет", "‼️"])
        importanceSegmentedControl.selectedSegmentIndex = 1
        importanceSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return importanceSegmentedControl
    }()
    private lazy var dateView: UIView = {
        let dateView = UIView()
        dateView.backgroundColor = Constans.Colors.mainViewColor
        dateView.translatesAutoresizingMaskIntoConstraints = false
        return dateView
    }()
    private lazy var dateTitleStackView: UIStackView = {
        let dateTitleStackView = UIStackView()
        dateTitleStackView.axis = .horizontal
        dateTitleStackView.alignment = .center
        dateTitleStackView.distribution = .fill
        dateTitleStackView.spacing = 10
        dateTitleStackView.translatesAutoresizingMaskIntoConstraints = false
        return dateTitleStackView
    }()
    private lazy var dateTitleLabel: UILabel = {
        let dateTitleLabel = UILabel()
        dateTitleLabel.text = Constans.Texts.makeUp
        dateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateTitleLabel
    }()
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = Constans.Colors.mainViewColor
        datePicker.contentHorizontalAlignment = .left
        datePicker.isHidden = true
        datePicker.tintColor = Constans.Colors.navBarItemColor
        datePicker.locale = .current
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    private lazy var dateSwitch: UISwitch = {
        let dateSwitch = UISwitch()
        dateSwitch.addTarget(self, action: #selector(didTogleDateSwitch), for: .valueChanged)
        dateSwitch.translatesAutoresizingMaskIntoConstraints = false
        return dateSwitch
    }()
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle(Constans.Texts.delete, for: .normal)
        deleteButton.setTitleColor(Constans.Colors.deleteButtonColor, for: .normal)
        deleteButton.backgroundColor = Constans.Colors.mainViewColor
        deleteButton.layer.cornerRadius = 10
        deleteButton.layer.masksToBounds = true
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        return deleteButton
    }()
    //MARK: - ViewController functions
    deinit {
        removeKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNorifications()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setConstraints()
    }
    //MARK: - Private functions
    private func setSwitch(state: Bool) {
        dateSwitch.isOn = state
        if dateSwitch.isOn {
            datePicker.isHidden = false
            let date = Date()
            datePicker.date = date.addingTimeInterval(TimeInterval(24 * 60 * 60))
            NotificationService.shared.requestAuthorization()

        } else {
            datePicker.isHidden = true
        }
    }
    
    private func setupUI() {
        scrollView.delegate = self
        title = Constans.Texts.titleAddingTask
        view.backgroundColor = Constans.Colors.backgroundColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constans.Texts.save, style: .done, target: self, action: #selector(saveCreatedTask))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Constans.Texts.cancel, style: .plain, target: self, action: #selector(cancelCreatingTask))
    }
    
    private func setConstraints() {
        scrollView.contentSize = contentSize
        contentView.frame.size = contentSize
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(textView)
        contentView.addSubview(stackView)
        contentView.addSubview(deleteButton)
        
        stackView.addArrangedSubview(importanceView)
        stackView.addArrangedSubview(dateView)
        
        importanceView.addSubview(importanceLabel)
        importanceView.addSubview(importanceSegmentedControl)
        
        dateView.addSubview(dateTitleStackView)
        dateView.addSubview(dateSwitch)
        
        dateTitleStackView.addArrangedSubview(dateTitleLabel)
        dateTitleStackView.addArrangedSubview(datePicker)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            textView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20),
            textView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 112),
            
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -20),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 112),
            
            importanceView.heightAnchor.constraint(equalToConstant: 55),
            importanceLabel.centerYAnchor.constraint(equalTo: importanceView.centerYAnchor),
            importanceLabel.leadingAnchor.constraint(equalTo: importanceView.leadingAnchor, constant: 10),
            importanceLabel.trailingAnchor.constraint(equalTo: importanceSegmentedControl.leadingAnchor, constant: -10),
            
            importanceSegmentedControl.centerYAnchor.constraint(equalTo: importanceView.centerYAnchor),
            importanceSegmentedControl.trailingAnchor.constraint(equalTo: importanceView.trailingAnchor, constant: -10),
            importanceSegmentedControl.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
            
            dateView.heightAnchor.constraint(equalToConstant: 55),
            
            dateSwitch.centerYAnchor.constraint(equalTo: dateView.centerYAnchor),
            dateSwitch.trailingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: -10),
            
            dateTitleStackView.centerYAnchor.constraint(equalTo: dateView.centerYAnchor),
            dateTitleStackView.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: 10),
            dateTitleStackView.trailingAnchor.constraint(equalTo: dateSwitch.leadingAnchor, constant: -10),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 56),
            deleteButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            deleteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
        ])
    }
    //MARK: - Public functions
    func configure(item: ToDoItem?, indexPath: IndexPath?) {
        self.indexPath = indexPath
        guard let item = item else {
            self.item = nil
            return
        }
        self.item = item
        textView.text = item.text
        switch item.importance {
        case .important:
            importanceSegmentedControl.selectedSegmentIndex = 2
        case .unimportant:
            importanceSegmentedControl.selectedSegmentIndex = 0
        case .ordinary:
            importanceSegmentedControl.selectedSegmentIndex = 1
        }
        if let deadline = item.deadline {
            setSwitch(state: true)
            datePicker.date = deadline
        } else {
            setSwitch(state: false)
        }
    }
    //MARK: - @objc functions
    @objc private func didTogleDateSwitch(sender: UISwitch!) {
        setSwitch(state: sender.isOn)
    }
    
    @objc private func didTapDeleteButton(sender: UIButton!) {
        if let id = item?.id {
            dismiss(animated: true) {
                self.delegate?.deleteCurrentItem(id: id)
            }
        } else {
            textView.text.removeAll()
            importanceSegmentedControl.selectedSegmentIndex = 1
            setSwitch(state: false)
            dismiss(animated: true)
        }
    }
    
    @objc private func saveCreatedTask() {
        if let oldItem = self.item {
            let newItem = ToDoItem(id: oldItem.id,
                                   text: textView.text,
                                   importance: Importance.convertFromIndex(index: importanceSegmentedControl.selectedSegmentIndex),
                                   deadline: dateSwitch.isOn ? datePicker.date : nil,
                                   isComplete: oldItem.isComplete,
                                   dateCreated: oldItem.dateCreated,
                                   dateChanged: Date())
            self.dismiss(animated: true) {
                self.delegate?.saveChangedItem(oldItem: oldItem, newItem: newItem, indexPath: self.indexPath!)
            }
        } else {
            let newItem = ToDoItem(id: UUID().uuidString,
                                   text: textView.text,
                                   importance: Importance.convertFromIndex(index: importanceSegmentedControl.selectedSegmentIndex),
                                   deadline: dateSwitch.isOn ? datePicker.date : nil,
                                   isComplete: false,
                                   dateCreated: Date(),
                                   dateChanged: Date())
            self.dismiss(animated: true) {
                self.delegate?.saveNewItem(newItem: newItem)
            }
        }
    }
    
    @objc private func cancelCreatingTask() {
        dismiss(animated: true)
    }
}
//MARK: - UIScrollViewDelegate
extension AddingItemViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
//MARK: - KeyboardManage
extension AddingItemViewController {
    private func registerForKeyboardNorifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        keyboardIsHidden = false
    }
    
    @objc private func keyboardWillHide() {
        keyboardIsHidden = true
    }
}
