//
//  PhoneInputView.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 22.01.2025.
//

import SwiftUI
import UIKit
import SnapKit

final class PhoneInputView: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controls
    
    private(set) lazy var pageLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Auth.Registration.title
        label.font = FontFamily.HelveticaNeue.bold.font(size: 32)
        label.textColor = Asset.Colors.Window.textColor.color
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Auth.PhoneNumber.header
        label.textColor = .gray
        label.font = FontFamily.HelveticaNeue.regular.font(size: 18)
        label.backgroundColor = .clear
        return label
    }()
    
    private(set) lazy var phoneNumberTextField: UITextField = {
        let textField = UITextFieldEx()
        textField.placeholder = "(000) 000-0000"
        
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        
        // Установка границ и цвета фона
        textField.backgroundColor = Asset.Colors.TextField.bgColor.color
        textField.textColor = Asset.Colors.TextField.textColor.color
        
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true // Обеспечивает обрезку углов
        textField.padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 10)
        
        textField.font = FontFamily.Inter.regular.font(size: 20)
        
        let prefixNumberView = UILabel()
        prefixNumberView.font = textField.font
        prefixNumberView.text = "+7"
        prefixNumberView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        prefixNumberView.textAlignment = .right
        
        let prefixView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        prefixView.backgroundColor = .clear
        prefixView.addSubview(prefixNumberView)
        
        textField.leftView = prefixView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private(set) lazy var getCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.Auth.getCode, for: .normal)
        button.titleLabel?.font = FontFamily.Inter.regular.font(size: 16)
        UIFont.systemFont(ofSize: 17)
        button.backgroundColor = Asset.Colors.Button.bgColor.color
        button.tintColor = Asset.Colors.Button.textColor.color
        button.layer.cornerRadius = 8
        return button
    }()
    
    private(set) lazy var loader: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    // MARK: - Setup
    
    private func setupUI() {
        self.backgroundColor = .white
        
        self.addSubview(pageLabel)
        self.addSubview(phoneNumberLabel)
        self.addSubview(phoneNumberTextField)
        self.addSubview(getCodeButton)
        self.addSubview(loader)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        pageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide).offset(150)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(pageLabel.snp.bottom).offset(30)
            make.leading.equalTo(phoneNumberTextField).offset(15)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(46)
        }
        
        getCodeButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(60)
            make.height.equalTo(50)
        }
        
        loader.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
}

#Preview {
    PhoneInputView().showLivePreview()
}
