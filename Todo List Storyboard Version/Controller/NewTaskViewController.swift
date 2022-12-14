//
//  NewTaskViewController.swift
//  Todo List Storyboard Version
//
//  Created by TheGIZzz on 29/8/2565 BE.
//

import UIKit
import Combine

class NewTaskViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deadlineLabel: UILabel!
    
    private var subscribers = Set<AnyCancellable>()
    var taskToEdit: Task?
    
    @Published private var taskString: String?
    @Published private var deadline: Date?
    
    weak var delegate: NewTasksVCDelegate?
    
    private lazy var calendarView: CalendarView = {
        let view = CalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        observeForm()
        setupGestures()
        observeKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        taskTextField.becomeFirstResponder()
    }
    
    private func observeForm() {
        NotificationCenter.default.publisher(for:
            UITextField.textDidChangeNotification).map { ($0.object as? UITextField)?.text
        }.sink { [unowned self] (text) in
            self.taskString = text
        }.store(in: &subscribers)
        
        $taskString.sink { [unowned self] (text) in
            self.saveButton.isEnabled = text?.isEmpty == false
        }.store(in: &subscribers)
        
        $deadline.sink { [unowned self] (date) in
            let currentDateTime = Date()
            self.deadlineLabel.text = date == nil ? currentDateTime.toString() : date?.toString()
            self.deadlineLabel.textColor = date == nil ? .secondaryLabel : UIColor(named: "AdaptColor")
        }.store(in: &subscribers)
    }
    
    private func setupViews() {
        backgroundView.backgroundColor = UIColor.init(white: 0.3, alpha: 0.4)
        containerViewButtonConstraint.constant = -containerView.frame.height
        if let taskToEdit = self.taskToEdit {
            taskTextField.text = taskToEdit.title
            taskString = taskToEdit.title
            deadline = taskToEdit.deadline
            saveButton.setTitle("Update", for: .normal)
            calendarView.selectDate(date: taskToEdit.deadline)
        }
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notifiaction: Notification) {
        let keyboardHeight = getKeyboardHeight(notifiacation: notifiaction)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { [unowned self] in
            self.containerViewButtonConstraint.constant = keyboardHeight - (200+8)
            self.view.layoutIfNeeded()
        }, completion: nil)
    
    }
    
    @objc private func keyboardWillHide(_ notifiaction: Notification) {
        containerViewButtonConstraint.constant = -containerView.frame.height
    }
    
    private func getKeyboardHeight(notifiacation: Notification) -> CGFloat {
        guard let keyboardHeight = (notifiacation.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return 0 }
        return keyboardHeight
    }
    
    
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    private func showCalendar() {
        view.addSubview(calendarView)
        
        let height: CGFloat = view.frame.height/2
        NSLayoutConstraint.activate([
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: height),
        ])
    }
    
    private func dismissCalendarView(completion: () -> Void) {
        calendarView.removeFromSuperview()
        completion()
    }
    
    @IBAction func calendarButtonTapped(_ sender: Any) {
        taskTextField.resignFirstResponder()
        showCalendar()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let taskString = self.taskString else {
            return
        }
        var task = Task(title: taskString, deadline: deadline)
        
        if let id = taskToEdit?.id {
            task.id = id
        }
        
        if taskToEdit == nil {
            delegate?.didAddTask(task: task)
        } else {
            delegate?.didEditTask(task: task)
        }
    }
    
}

extension NewTaskViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if calendarView.isDescendant(of: view) { // calendar is a subview
            if touch.view?.isDescendant(of: calendarView) == false {
                dismissCalendarView { [unowned self] in
                    self.taskTextField.becomeFirstResponder()
                }
            }
            return false
        }
        return true
    }
}

extension NewTaskViewController: CalendarViewDelegate {
    
    func calendarViewDidSelectDate(date: Date) {
        dismissCalendarView {
            self.taskTextField.becomeFirstResponder()
            self.deadline = date
        }
    }
    
    func calendarViewDidTapRemoveButton() {
        dismissCalendarView {
            self.taskTextField.becomeFirstResponder()
            self.deadline = nil
        }
    }
}
