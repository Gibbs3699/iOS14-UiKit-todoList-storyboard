//
//  DoneTasksTableViewCell.swift
//  Todo List Storyboard Version
//
//  Created by TheGIZzz on 1/9/2565 BE.
//

import UIKit

class DoneTasksTableViewCell: UITableViewCell {

    static let identifier = "DoneTasksTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with task: Task) {
        titleLabel.text = task.title
    }

}
