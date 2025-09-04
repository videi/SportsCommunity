//
//  UITextField+Extensions.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 24.08.2025.
//

import UIKit

extension UITextField {
    //TODO: Ввести property UIControl.Event, чтобы задавать когда должен срабатывать
    
    private struct AssociatedKeys {
        static var validator: UInt8 = 1
        static var isValid: UInt8 = 2
        static var inputFilter: UInt8 = 3
    }
    
    var validator: ((String) -> Bool)? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.validator) as? (String) -> Bool }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.validator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if newValue != nil {
                self.addTarget(self, action: #selector(validateOnEditingEnd), for: .editingDidEnd)
            }
        }
    }
    
    var isValid: Bool {
        return (objc_getAssociatedObject(self, &AssociatedKeys.isValid) as? Bool) ?? true
    }
    
    var inputFilter: ((Character) -> Bool)? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.inputFilter) as? (Character) -> Bool }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.inputFilter, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if newValue != nil {
                self.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
            }
        }
    }
    
    @objc private func validateOnEditingEnd() {
        guard let validator = validator else { return }
        let text = self.text ?? ""
        let isValid = validator(text)
        applyValidationStyle(isValid: isValid)
    }
    
    @objc func textFieldChanged(_ textField: UITextField) {
        guard let filter = inputFilter, let text = self.text else { return }
        let filtered = text.filter { filter($0) }
        if filtered != text {
            self.text = filtered
        }
    }
    
    private func applyValidationStyle(isValid: Bool) {
        UIView.animate(withDuration: 0.25) {
            if isValid {
                self.layer.borderWidth = 0
            } else {
                self.layer.cornerRadius = 6
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.systemRed.cgColor
            }
        }
    }
}
