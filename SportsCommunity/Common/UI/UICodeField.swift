//
//  CodeInputView.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 03.11.2024.
//

import UIKit
import SnapKit
import SwiftUI

private enum UICodeFieldColors {
    static let defaultBackground = UIColor(hex: "#F2F3F5")
    static let validBorder = UIColor.green.cgColor
    static let invalidBorder = UIColor(hex: "#F2F3F5")?.cgColor
}

final class UICodeField: UIControl, UITextFieldDelegate, UITextFieldDelegateEx {
    
    // MARK: - Property
    
    private var codeTextField: [UITextField] = []
    private var stackView: UIStackView
    
    // Замыкание для обработки события завершения ввода
    var onComplete: ((String) -> Void)?
    
    // MARK: - Init
    
    // Конструктор, который принимает количество текстовых полей
    init(numberOfDigits: Int) {
        stackView = UIStackView()
        super.init(frame: .zero)
        setupTextFields(numberOfDigits: numberOfDigits)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        // Логика для обработки изменений в текстовых полях
        
        // Проверка на удаление
        if let currentText = textField.text {
            
            // Удаление цифры
            if currentText.count == 0 {
                // Найдем индекс текущего текстового поля
                if let index = codeTextField.firstIndex(of: textField) {
                    // Перейдем к предыдущему текстовому полю, если оно существует
                    if index > 0 {
                        codeTextField[index - 1].becomeFirstResponder()
                    }
                }
            }
            // Добавление цифры
            else if currentText.count == 1 {
                // Проверка, если текстовое поле не пустое и заполнили 1 символ
                if let index = codeTextField.firstIndex(of: textField) {
                    // Перейдем к следующему текстовому полю, если оно существует
                    if index < codeTextField.count - 1 {
                        codeTextField[index + 1].becomeFirstResponder()
                    }
                }
            }
        }
        
        updateBorderColor(textField)
        
        if codeTextField.allSatisfy({ $0.text?.count == 1 }) {
            let code = codeTextField.compactMap { $0.text }.joined()
            onComplete?(code) // Вызываем замыкание
        }
    }
    
    // MARK: - Method
    
    private func setupView() {
        // Настройка StackView
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        // Добавляем StackView на основной вид
        addSubview(stackView)
        
        // Устанавливаем ограничения для StackView
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // Заполнение всего пространства
        }
        
        for textField in codeTextField {
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            
            // Устанавливаем ограничение для каждого текстового поля
            textField.snp.makeConstraints { make in
                make.width.equalTo(50)
                make.height.equalTo(50)
            }
        }
    }
    
    private func setupTextFields(numberOfDigits: Int) {
        _ = [UITextField]()
        
        for _ in 0..<numberOfDigits {
            let textField = UITextFieldEx()
            textField.backgroundColor = UICodeFieldColors.defaultBackground
            textField.borderStyle = .none
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 5
            textField.layer.borderColor = UICodeFieldColors.invalidBorder
            textField.textAlignment = .center
            textField.font = UIFont(name: "AvenirNext-Regular", size: 24)
            textField.keyboardType = .numberPad
            textField.widthAnchor.constraint(equalToConstant: 50).isActive = true
            textField.caretOrientation = .horizontal
            textField.delegate = self
            textField.deleteDelegate = self
            codeTextField.append(textField)
            stackView.addArrangedSubview(textField)
        }
    }
    
    private func updateBorderColor(_ textField: UITextField) {
        textField.layer.borderColor = (textField.text?.isEmpty ?? true) ? UICodeFieldColors.invalidBorder : UICodeFieldColors.validBorder
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Выполняется вставка текста
        if string.count > 1 {
            guard let index = codeTextField.firstIndex(of: textField) else { return false}
            
            // Получаем массив символов из вставляемой строки
            let characters = Array(string)
            
            for (offset, char) in characters.enumerated() {
                let targetIndex = index + offset
                if targetIndex < codeTextField.count {
                    codeTextField[targetIndex].text = String(char)
                    codeTextField[targetIndex].sendActions(for: .editingChanged)
                }
            }
            
            return false
        }
        // Разрешаем ввод только одного символа
        else if let currentText = textField.text, currentText.count >= 1 && !string.isEmpty {
            return false
        }
        
        return true
    }
    
    func textFieldDidPressDelete(_ textField: UITextField) {
        // Проверяем, если нажата клавиша удаления и текущее поле пустое
        if let text = textField.text, text.isEmpty {
            if let index = codeTextField.firstIndex(of: textField), index > 0 {
                let previousTextField = codeTextField[index - 1]
                previousTextField.text = "" // Удаляем текст в предыдущем поле
                updateBorderColor(previousTextField)
                previousTextField.becomeFirstResponder() // Переходим к предыдущему полю
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        for textField in codeTextField {
            if textField.text?.isEmpty ?? true {
                textField.becomeFirstResponder()
                return
            }
        }
    }
}
