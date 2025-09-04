//
//  ProfileEditView.swift
//  ApplicationName
//
//  Created by Илья Макаров on 14.08.2025
//

import SwiftUI
import UIKit
import SnapKit

class ProfileEditView: UIView {
    
    //MARK: - UI
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    let profileIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        imageView.image = UIImage(systemName: "person.fill")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        )
        return imageView
    }()
    
    let surnameTextField = ProfileEditView.makeNameTextField(placeholder: L10n.Main.Profile.Edit.TexField.surname)
    let nameTextField = ProfileEditView.makeNameTextField(placeholder: L10n.Main.Profile.Edit.TexField.name)
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 16)
        textField.placeholder = L10n.Main.Profile.Edit.TexField.email
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
        textField.validator = { text in
            let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let range = NSRange(text.startIndex..<text.endIndex, in: text)
            let matches = detector?.matches(in: text, options: [], range: range)
            return matches?.first?.url?.scheme == "mailto" && matches?.first?.range.length == text.utf16.count
        }
        return textField
    }()
    
    var birthDateField: UIDateField = {
        let dateField = UIDateField()
        dateField.title = L10n.Main.Profile.Edit.TexField.birthday
        dateField.date = Date.now
        return dateField
    }()
    
    let editAvatarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.Main.Profile.Edit.Button.changePhoto, for: .normal)
        button.titleLabel?.font = FontFamily.Inter.regular.font(size: 16)
        button.backgroundColor = Asset.Colors.Button.bgColor.color
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.Main.Profile.Edit.Button.logout, for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = FontFamily.Inter.regular.font(size: 16)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = Asset.Colors.Button.bgColor.color.cgColor
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private(set) lazy var loader: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        self.backgroundColor = .white

        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(profileImageView)
        profileImageView.addSubview(profileIconImageView)

        contentView.addSubview(editAvatarButton)

        contentView.addSubview(stackView)
        stackView.addArrangedSubview(surnameTextField)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(emailTextField)
        
        contentView.addSubview(birthDateField)
        contentView.addSubview(logoutButton)
        
        contentView.addSubview(loader)
    }
    
    private func setupConstraints() {
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        profileIconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        editAvatarButton.snp.makeConstraints { make in
            make.top.equalTo(profileIconImageView.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(52)
            make.height.equalTo(42)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(editAvatarButton.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        birthDateField.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(stackView.spacing)
            make.left.right.equalToSuperview().inset(16)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(birthDateField.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).offset(-24)
        }
        
        loader.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
    }
}

extension ProfileEditView {
    private static func makeNameTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16)
        textField.autocapitalizationType = .words
        textField.returnKeyType = .done
        textField.validator = { text in
            let regex = "^[A-Za-zА-Яа-яЁё ]+$"
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
        }
        textField.inputFilter = { char in
            let pattern = "[A-Za-zА-Яа-яЁё ]"
            let str = String(char)
            return str.range(of: pattern, options: .regularExpression) != nil
        }
        return textField
    }
}

#Preview {
    ProfileEditView().showLivePreview()
}
