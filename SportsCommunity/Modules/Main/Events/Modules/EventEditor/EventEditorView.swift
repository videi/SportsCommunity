//
//  EventEditorView.swift
//  ApplicationName
//
//  Created by Илья Макаров on 12.08.2025
//

import SwiftUI
import UIKit
import SnapKit

final class EventEditorView: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controls

    let nameTextField: UIFloatLabelTextField = makeFloatLabelTextField(title: "Наименование мероприятия")
    let addressTextField: UIFloatLabelTextField = makeFloatLabelTextField(title: "Адрес")
    
    let maxParticipantsTextField: UIFloatLabelTextField = {
        let floatLabelTextField = makeFloatLabelTextField(title: "Максимальное число участников")
        floatLabelTextField.textField.keyboardType = .numberPad
        floatLabelTextField.textField.validator = { text in
            let regex = "^[0-9]+$"
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
        }
        return floatLabelTextField
    }()
    
    var dateField: UIDateField = {
        let dateField = UIDateField()
        dateField.title = "Дата и время"
        dateField.date = Date.now
        dateField.datePickerMode = .dateAndTime
        dateField.dateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter
        }()
        return dateField
    }()
    
    let sportPickerViewField: UIPickerViewField = {
        let pickerViewField = UIPickerViewField()
        pickerViewField.placeholder = "Выберите вид спорта"
        return pickerViewField
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    private(set) lazy var loader: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    // MARK: - Setup
    
    private func setupUI() {
        self.backgroundColor = .white
        
        addSubview(stackView)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(addressTextField)
        stackView.addArrangedSubview(maxParticipantsTextField)
        addSubview(dateField)
        addSubview(sportPickerViewField)
        
        addSubview(loader)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        dateField.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        sportPickerViewField.snp.makeConstraints { make in
            make.top.equalTo(dateField.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        loader.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private static func makeFloatLabelTextField(title: String) -> UIFloatLabelTextField {
        let floatLabelTextField = UIFloatLabelTextField()
        floatLabelTextField.title = title
        floatLabelTextField.textField.borderStyle = .roundedRect
        floatLabelTextField.textField.keyboardType = .default
        floatLabelTextField.textField.returnKeyType = .done
        return floatLabelTextField
    }
}

#Preview {
    EventEditorView().showLivePreview()
}
