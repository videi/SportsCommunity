//
//  UIDateField.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 23.08.2025.
//

import SwiftUI
import UIKit
import SnapKit

final class UIDateField: UIControl {
    
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.textColor = .placeholderText
        return label
    }()
    
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        return datePicker
    }()
    
    private let removeDateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить дату", for: .normal)
        button.titleLabel?.font = FontFamily.Inter.regular.font(size: 16)
        button.backgroundColor = .none
        button.setTitleColor(Asset.Colors.Button.bgColor.color, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private let separator1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
        
    private let separator2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private let stackView = UIStackView()
    private let headerStack = UIStackView()
    
    // MARK: - Properties
    
    private var isExpanded = false
    
    var datePickerMode: UIDatePicker.Mode = .date {
        didSet {
            datePicker.datePickerMode = datePickerMode
        }
    }
    
    var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    var borderColor: UIColor = .systemGray5 {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    var cornerRadius: CGFloat = 6.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    var date: Date? = nil {
        didSet {
            guard let date else {
                rightLabel.text = .none
                return
            }
            
            rightLabel.text = dateFormatter.string(from: date)
        }
    }
    
    var dateString: String? {
        guard let date else { return nil }
        return dateFormatter.string(from: date)
    }
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var title: String = "" {
        didSet {
            leftLabel.text = title
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupAppearance()
        setupTarget()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupAppearance()
        setupTarget()
    }
    
    private func setupViews() {
        headerStack.axis = .horizontal
        headerStack.distribution = .fill
        headerStack.addArrangedSubview(leftLabel)
        headerStack.addArrangedSubview(rightLabel)
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(headerStack)
        stackView.addArrangedSubview(separator1)
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(separator2)
        stackView.addArrangedSubview(removeDateButton)
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        separator1.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        separator2.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        removeDateButton.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        datePicker.isHidden = !self.isExpanded
        removeDateButton.isHidden = !self.isExpanded
        separator1.isHidden = !self.isExpanded
        separator2.isHidden = !self.isExpanded
    }
    
    private func setupAppearance() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = true
    }
    
    private func setupTarget() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleExpanded))
        addGestureRecognizer(tap)
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        removeDateButton.addTarget(self, action: #selector(removeDateTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func toggleExpanded() {
        sendActions(for: .touchUpInside)
        
        if isExpanded {
            UIView.animate(withDuration: 0.1, animations: {
                self.datePicker.alpha = 0
                self.removeDateButton.alpha = 0
                self.separator1.alpha = 0
                self.separator2.alpha = 0
            }, completion: { _ in
                self.separator1.isHidden = true
                self.separator2.isHidden = true
                self.datePicker.isHidden = true
                self.removeDateButton.isHidden = true
                self.layoutIfNeeded()
            })
        } else {
            self.datePicker.isHidden = false
            self.removeDateButton.isHidden = false
            self.separator1.isHidden = false
            self.separator2.isHidden = false
            
            self.datePicker.alpha = 0
            self.removeDateButton.alpha = 0
            self.separator1.alpha = 0
            self.separator2.alpha = 0
            
            UIView.animate(withDuration: 0.1, delay: 0, animations: {
                self.separator1.alpha = 1
                self.datePicker.alpha = 1
                self.separator2.alpha = 1
                self.removeDateButton.alpha = 1
            }, completion: { _ in
                self.layoutIfNeeded()
            })
        }
        
        isExpanded.toggle()
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        self.date = sender.date
        sendActions(for: .valueChanged)
    }
    
    @objc private func removeDateTapped() {
        self.date = nil
        sendActions(for: .valueChanged)
    }
    
   func enableDismissKeyboardOnTap(in view: UIView) {
       self.addAction(UIAction { _ in view.endEditing(true)}, for: .touchUpInside)
   }
}
