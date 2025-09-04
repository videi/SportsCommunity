//
//  CodeInputView.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 22.01.2025.
//

import SwiftUI
import UIKit
import SnapKit

final class CodeInputView: UIView {
    
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
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Auth.CodeInput.header
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .clear
        return label
    }()
    
    private(set) lazy var codeInput: UICodeField = {
        let codeInputView = UICodeField(numberOfDigits: 4)
        return codeInputView
    }()
    
    private(set) lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.HelveticaNeue.regular.font(size: 17)
        label.textColor = .gray
        label.backgroundColor = .clear
        return label
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
        self.addSubview(getCodeButton)
        self.addSubview(codeLabel)
        self.addSubview(codeInput)
        self.addSubview(timerLabel)
        self.addSubview(loader)
        
        getCodeButton.isHidden = true
        
        setupConstraints()
    }
 
    private func setupConstraints() {
        
        pageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide).offset(150)
        }
        
        codeLabel.snp.makeConstraints { make in
            make.top.equalTo(pageLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        codeInput.snp.makeConstraints { make in
            make.top.equalTo(codeLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(codeInput.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        getCodeButton.snp.makeConstraints { make in
            make.top.equalTo(codeInput.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(60)
            make.height.equalTo(50)
        }
        
        loader.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
}

#Preview {
    CodeInputView().showLivePreview()
}
