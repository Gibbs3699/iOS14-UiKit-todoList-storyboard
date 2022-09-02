//
//  DoneTasksTableViewController.swift
//  Todo List Storyboard Version
//
//  Created by TheGIZzz on 29/8/2565 BE.
//

import UIKit

class DoneTasksTableViewController: UITableViewController, Animatable {

    private let databaseManager = DatabaseManager()
    
    private var tasks: [Task] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        addTasksListener()
    }
    
    private func addTasksListener() {
        databaseManager.addTaskListener(forDoneTasks: true) { [weak self] (result) in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
            case .failure(let error):
                self?.showToast(state: .error, message: error.localizedDescription, duration: 2.0)
            }
        }
    }
    
    private func handleActionButton(for task: Task) {
        guard let id = task.id else { return }
        databaseManager.updateTaskStatus(id: id, isDone: false) { [weak self] (result) in
            switch result {
            case .success(_):
                self?.showToast(state: .info, message: "Moved to Ongoing", duration: 2.0)
            case .failure(let error):
                self?.showToast(state: .error, message: error.localizedDescription, duration: 2.0)
                print(error.localizedDescription)
            }
        }
    }

}

extension DoneTasksTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: DoneTasksTableViewCell.identifier, for: indexPath) as! DoneTasksTableViewCell
        cell.configure(with: task)
        cell.actionButtonDidTap = { [weak self] in
            self?.handleActionButton(for: task)
        }
        
        return cell
    }
}
