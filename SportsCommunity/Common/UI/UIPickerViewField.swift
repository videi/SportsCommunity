//
//  UIPickerViewField.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 03.09.2025.
//

import Foundation
import UIKit

protocol UIPickerViewFieldDelegate: AnyObject {
    func pickerViewField(_ pickerViewField: UIPickerViewField, didSelect item: String)
}

final class UIPickerViewField: UITextField {

    private let picker = UIPickerView()
    private var items: [String] = []
    
    weak var delegateField: UIPickerViewFieldDelegate?
    
    private(set) var selectedItem: String? {
        didSet {
            text = selectedItem
        }
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        borderStyle = .roundedRect
        
        picker.delegate = self
        picker.dataSource = self
        inputView = picker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        toolbar.setItems([doneButton], animated: false)
        inputAccessoryView = toolbar
    }
    
    func setItems(_ newItems: [String]) {
        items = newItems
        picker.reloadAllComponents()
        selectedItem = nil
    }
    
    func setSelectedItem(_ item: String) {
        if let index = items.firstIndex(of: item) {
            picker.selectRow(index, inComponent: 0, animated: false)
            pickerView(picker, didSelectRow: index, inComponent: 0)
        }
    }
}

extension UIPickerViewField {
    @objc private func doneTapped() {
        resignFirstResponder()
    }
}

extension UIPickerViewField {
    
    override var canBecomeFirstResponder: Bool {
        true // чтобы inputView (UIPickerView) работал
    }
    
    // Убираем каретку
    override func caretRect(for position: UITextPosition) -> CGRect {
        .zero
    }
    
    // Запрещаем выделение текста
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        []
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
}

extension UIPickerViewField: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        items.count
    }
}

extension UIPickerViewField: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = items[row]
        delegateField?.pickerViewField(self, didSelect: items[row])
    }
}
