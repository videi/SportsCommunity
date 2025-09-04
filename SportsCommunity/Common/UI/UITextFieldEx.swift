//
//  UITextFieldEx.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 05.11.2024.
//

import UIKit

enum CaretOrientation {
    case horizontal
    case vertical
}

protocol UITextFieldDelegateEx: AnyObject {
    func textFieldDidPressDelete(_ textField: UITextField)
}

class UITextFieldEx : UITextField, UITextFieldDelegate {
    
    // MARK: - Property
    
    var caretOrientation: CaretOrientation = .vertical
    
    // Отступы
    var padding = UIEdgeInsets(
        top: 0,
        left: 0,
        bottom: 0,
        right: 0
    )
    
    // Параметр для максимального количества символов
    var maxLength: Int?
    weak var deleteDelegate: UITextFieldDelegateEx?
    
    // MARK: - Method
    
    override public func deleteBackward() {
        
        deleteDelegate?.textFieldDidPressDelete(self)
        super.deleteBackward()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: padding)
    }
    
    // Переопределяем метод отрисовки каретки
    override func caretRect(for position: UITextPosition) -> CGRect {
        var originalRect = super.caretRect(for: position)
        
        if caretOrientation == .horizontal {
            
            // Устанавливаем высоту каретки (толщина)
            originalRect.size.height = 2
            
            // Определяем ширину каретки на основе ширины символа "W" текущего шрифта
            if let font = self.font {
                let symbolWidth = "W".size(withAttributes: [.font: font]).width
                originalRect.size.width = symbolWidth
            }
            
            // Центрируем каретку по оси X
            originalRect.origin.x = (self.bounds.width - originalRect.size.width) / 2
            
            originalRect.origin.y = self.bounds.height - originalRect.size.height - 8 // Отступ от нижнего края
        }
        
        return originalRect
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Проверка ограничения длины текста
        guard let maxLength = maxLength else {
            return true
        }
        
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return updatedText.count <= maxLength
    }
}
