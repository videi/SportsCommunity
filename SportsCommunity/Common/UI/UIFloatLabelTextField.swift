//
//  UIFloatLabelTextField.swift
//  SportsCommunity
//
//  Created by Илья Макаров on 04.09.2025.
//

import Foundation
import UIKit
import SnapKit

final class UIFloatLabelTextField: UIView {

    // MARK: - Subviews
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.alpha = 0
        return label
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    // MARK: - Properties
    var title: String? {
        didSet {
            titleLabel.text = title
            textField.placeholder = title
        }
    }
    
    var text: String? {
        didSet {
            textField.text = text
            titleLabel.alpha = 1
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(textField)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(6)
            make.top.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupTarget() {
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    // MARK: - Animations
    @objc private func editingChanged() {
        updateTitleVisibility()
    }
    
    @objc private func editingDidEnd() {
        let isEmpty = textField.text?.isEmpty ?? true
        animateTitle(up: !isEmpty)
    }
    
    private func updateTitleVisibility() {
        let isEmpty = textField.text?.isEmpty ?? true
        animateTitle(up: !isEmpty)
    }
    
    private func animateTitle(up: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.titleLabel.alpha = up ? 1 : 0
        }
    }
}
