//
//  TaskViewController.swift
//  Todo List Storyboard Version
//
//  Created by TheGIZzz on 28/8/2565 BE.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ongoingTasksContainerView: UIView!
    @IBOutlet weak var doneTasksContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        ongoingTasksContainerView.isHidden = true
        doneTasksContainerView.isHidden = false
        
        setupSegmentedControl()
    }

    private func setupSegmentedControl() {
        menuSegmentedControl.removeAllSegments() // remove selected
        
        MenuSection.allCases.enumerated().forEach { (index, section) in
            menuSegmentedControl.insertSegment(withTitle: section.rawValue, at: index, animated: true)
        }
        
        menuSegmentedControl.selectedSegmentIndex = 0
        showContainerView(for: .ongoing)
        
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showContainerView(for: .ongoing)
        case 1:
            showContainerView(for: .done)
        default:
            break
        }
    }
    
    
    private func showContainerView(for section: MenuSection) {
        switch section {
        case .ongoing:
            ongoingTasksContainerView.isHidden = false
            doneTasksContainerView.isHidden = true
        case .done:
            ongoingTasksContainerView.isHidden = true
            doneTasksContainerView.isHidden = false
        }
        
    }
    
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showNewTask", sender: nil)
    }
    
}

