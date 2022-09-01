//
//  OngoingTasksTableViewController.swift
//  Todo List Storyboard Version
//
//  Created by TheGIZzz on 29/8/2565 BE.
//

import UIKit

class OngoingTasksTableViewController: UITableViewController {

    private let databaseManager = DatabaseManager()
    
    private var tasks: [Task] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTasksListener()
    }
    
    private func addTasksListener() {
        databaseManager.addTaskListener(forDoneTasks: false) { [weak self] (result) in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func handleActionButton(for task: Task) {
        guard let id = task.id else { return }
        databaseManager.updateTaskToDone(id: id) { (result) in
            switch result {
            case .success(_):
                print("set to done succesfully")
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension OngoingTasksTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: OngoingTasksTableViewCell.identifier, for: indexPath) as! OngoingTasksTableViewCell
        cell.configure(with: task)
        cell.actionButtonDidTap = { [weak self] in
            print("Tapped!!! \(task.title)")
            self?.handleActionButton(for: task)
        }
        
        return cell
    }
}
