//
//  TaskViewController.swift
//  Todo List Storyboard Version
//
//  Created by TheGIZzz on 28/8/2565 BE.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupSegmentedControl()
    }

    private func setupSegmentedControl() {
        menuSegmentedControl.removeAllSegments() // remove selected
        
        menuSection.allCases.enumerated().forEach { (index, section) in
            menuSegmentedControl.insertSegment(withTitle: section.rawValue, at: index, animated: true)
        }
        
        menuSegmentedControl.selectedSegmentIndex = 0
        
    }
}

