//
//  CalendarView.swift
//  Todo List Storyboard Version
//
//  Created by TheGIZzz on 2/9/2565 BE.
//

import UIKit
import FSCalendar

class CalendarView: UIView {

    weak var delegate: CalendarViewDelegate?
    
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.delegate = self
        return calendar
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(removeButtonTapped(_:)), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select deadline"
        label.font = UIFont(name: "AvenitNext-DemiBold", size: 14)
        label.textAlignment = .center
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, calendar, removeButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if calendar.selectedDate == nil {
            removeButton.removeFromSuperview()
        } else if removeButton.isDescendant(of: stackView) == false {
            stackView.addArrangedSubview(removeButton)
        }
    }
    
    private func setupViews() {
        backgroundColor = .white
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            calendar.heightAnchor.constraint(equalToConstant: 240),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            removeButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc func removeButtonTapped(_ sender: UIButton) {
        if let selectedDate = calendar.selectedDate {
            calendar.deselect(selectedDate)
            delegate?.calendarViewDidTapRemoveButton()
        }
    }
    
    func selectDate(date: Date?) {
        calendar.select(date, scrollToDate: true)
    }
    
}

extension CalendarView: FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        delegate?.calendarViewDidSelectDate(date: date)
        print("Picked date: \(date)")
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return UIColor(named: "AdaptColor")
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .systemGreen
    }
    
}
