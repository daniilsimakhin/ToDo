//
//  AddingTaskViewController.swift
//  ToDo
//
//  Created by Даниил Симахин on 17.08.2022.
//

import UIKit

protocol AddingTaskViewControllerDelegate: AnyObject {
    func saveNewTask(newTask: TaskModel)
    func saveChangedTask(oldTask: TaskModel, newTask: TaskModel, indexPath: IndexPath)
    func deleteCurrentTask(id: String, indexPath: IndexPath)
}

final class AddingTaskViewController: UIViewController {
    
    private var task: TaskModel?
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
        dateTitleStackView.axis = .vertical
        dateTitleStackView.alignment = .leading
        dateTitleStackView.distribution = .fill
        dateTitleStackView.spacing = 3
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
        datePicker.tintColor = Constans.Colors.navBarTaskColor
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
    
    // MARK: - ViewController functions
    
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
    
    // MARK: - Private functions
    
    private func setSwitch(state: Bool) {
        dateSwitch.setOn(state, animated: true)
        if dateSwitch.isOn {
            NotificationService.shared.requestAuthorization { granted in
                DispatchQueue.main.async {
                    if !granted {
                        let alertController = UIAlertController(title: "Уведомления отключены", message: "Чтобы использовать напоминания необходимо включить их в настройках", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Перейти в настройки", style: .default, handler: { _ in
                            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                            if UIApplication.shared.canOpenURL(settingsURL) {
                                UIApplication.shared.open(settingsURL) { _ in }
                            }
                        }))
                        alertController.addAction(UIAlertAction(title: "Отмена", style: .default, handler: { _ in
                            self.setSwitch(state: false)
                        }))
                        self.present(alertController, animated: true)
                    }
                }
            }
            datePicker.isHidden = false
            let date = Date()
            datePicker.date = date.addingTimeInterval(TimeInterval(24 * 60 * 60))
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
            
            importanceView.heightAnchor.constraint(equalToConstant: 55),
            importanceLabel.centerYAnchor.constraint(equalTo: importanceView.centerYAnchor),
            importanceLabel.leadingAnchor.constraint(equalTo: importanceView.leadingAnchor, constant: 10),
            importanceLabel.trailingAnchor.constraint(equalTo: importanceSegmentedControl.leadingAnchor, constant: -10),
            
            importanceSegmentedControl.centerYAnchor.constraint(equalTo: importanceView.centerYAnchor),
            importanceSegmentedControl.trailingAnchor.constraint(equalTo: importanceView.trailingAnchor, constant: -10),
            importanceSegmentedControl.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
            
            dateView.topAnchor.constraint(equalTo: dateTitleStackView.topAnchor, constant: -15),
            dateView.bottomAnchor.constraint(equalTo: dateTitleStackView.bottomAnchor, constant: 15),
            
            dateSwitch.centerYAnchor.constraint(equalTo: dateView.centerYAnchor),
            dateSwitch.trailingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: -10),
            
            dateTitleStackView.centerYAnchor.constraint(equalTo: dateView.centerYAnchor),
            dateTitleStackView.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: 10),
            dateTitleStackView.trailingAnchor.constraint(equalTo: dateSwitch.leadingAnchor, constant: -10),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 56),
            deleteButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            deleteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        ])
    }
    
    private func invalidDateAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Дата указана некорректно, отключите ее или укажите другую.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Отключить дату", style: .default) { _ in
            self.setSwitch(state: false)
        })
        
        alert.addAction(UIAlertAction(title: "Указать другую дату", style: .default) { _ in
            DispatchQueue.main.async {
                self.datePicker.setDate(Date.tomorrow, animated: true)
            }
        })
        
        self.present(alert, animated: true)
    }
    // MARK: - Public functions
    func configure(task: TaskModel?, indexPath: IndexPath?) {
        self.indexPath = indexPath
        guard let task = task else {
            self.task = nil
            return
        }
        self.task = task
        textView.text = task.text
        switch task.importance {
        case .important:
            importanceSegmentedControl.selectedSegmentIndex = 2
        case .unimportant:
            importanceSegmentedControl.selectedSegmentIndex = 0
        case .ordinary:
            importanceSegmentedControl.selectedSegmentIndex = 1
        }
        if let deadline = task.deadline {
            setSwitch(state: true)
            datePicker.date = deadline
        } else {
            setSwitch(state: false)
        }
    }
    
    // MARK: - @objc functions
    
    @objc private func didTogleDateSwitch(sender: UISwitch!) {
        setSwitch(state: sender.isOn)
    }
    
    @objc private func didTapDeleteButton(sender: UIButton!) {
        if let id = task?.id, let indexPath = indexPath {
            dismiss(animated: true) {
                self.delegate?.deleteCurrentTask(id: id, indexPath: indexPath)
            }
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func saveCreatedTask() {
        if dateSwitch.isOn && datePicker.date <= Date() {
            invalidDateAlert()
            return
        }
        if let oldTask = self.task {
            let newTask = TaskModel(id: oldTask.id,
                                    text: textView.text,
                                    importance: Importance.allCases[importanceSegmentedControl.selectedSegmentIndex],
                                    deadline: dateSwitch.isOn ? datePicker.date : nil,
                                    isComplete: oldTask.isComplete,
                                    dateCreated: oldTask.dateCreated,
                                    dateChanged: Date())
            self.dismiss(animated: true) {
                self.delegate?.saveChangedTask(oldTask: oldTask, newTask: newTask, indexPath: self.indexPath!)
            }
        } else {
            let newTask = TaskModel(id: UUID().uuidString,
                                    text: textView.text,
                                    importance: Importance.allCases[importanceSegmentedControl.selectedSegmentIndex],
                                    deadline: dateSwitch.isOn ? datePicker.date : nil,
                                    isComplete: false,
                                    dateCreated: Date(),
                                    dateChanged: Date())
            self.dismiss(animated: true) {
                self.delegate?.saveNewTask(newTask: newTask)
            }
        }
    }
    
    @objc private func cancelCreatingTask() {
        dismiss(animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension AddingTaskViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}

// MARK: - KeyboardManage

extension AddingTaskViewController {
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
