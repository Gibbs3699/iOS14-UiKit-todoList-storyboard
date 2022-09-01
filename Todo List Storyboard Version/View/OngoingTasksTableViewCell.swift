//
//  OngoingTasksTableViewCell.swift
//  Todo List Storyboard Version
//
//  Created by TheGIZzz on 31/8/2565 BE.
//

import UIKit

class OngoingTasksTableViewCell: UITableViewCell {

    static let identifier = "OngoingTasksTableViewCell"
    
    var actionButtonDidTap: (() -> Void)?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        actionButtonDidTap?()
    }
    
    func configure(with task: Task) {
        titleLabel.text = task.title
    }

}
