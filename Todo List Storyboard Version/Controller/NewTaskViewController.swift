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
    
    private var subscribers = Set<AnyCancellable>()
    @Published private var taskString: String?
    
    private let databaseManager = DatabaseManager()
    
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
    }
    
    private func setupViews() {
        backgroundView.backgroundColor = UIColor.init(white: 0.3, alpha: 0.4)
        containerViewButtonConstraint.constant = -containerView.frame.height
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
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
    
    @IBAction func calendarButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let taskString = taskString else {
            return
        }
            
        let task = Task(title: taskString)
        
        databaseManager.addTask(task: task) { (result) in
            switch result {
            case .success:
                print("Saved!")
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
}

