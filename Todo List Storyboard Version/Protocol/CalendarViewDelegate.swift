//
//  CalendarViewDelegate.swift
//  Todo List Storyboard Version
//
//  Created by TheGIZzz on 3/9/2565 BE.
//

import Foundation

protocol CalendarViewDelegate: class {
    func calendarViewDidSelectDate(date: Date)
    func calendarViewDidTapRemoveButton()
}
