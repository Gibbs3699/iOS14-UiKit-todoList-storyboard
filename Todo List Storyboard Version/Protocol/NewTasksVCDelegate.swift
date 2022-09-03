//
//  TasksVCDelegate.swift
//  Todo List Storyboard Version
//
//  Created by TheGIZzz on 31/8/2565 BE.
//

import Foundation

protocol NewTasksVCDelegate: class {
    func didAddTask(task: Task)
    func didEditTask(task: Task)
}
