//
//  AuthViewController.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 27.09.2024.
//

import UIKit

final class PhoneInputViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Property
    
    private let contentView = PhoneInputView()
    private let viewModel: PhoneInputViewModel
    
    // MARK: - Init
    
    init(viewModel: PhoneInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupBinding()
    }
    
    // MARK: - Setup
    
    private func setupTarget() {
        contentView.phoneNumberTextField.addTarget(self, action: #selector(formatPhoneNumber), for: .editingChanged)
        contentView.getCodeButton.addTarget(self, action: #selector(getCodeButtonTapped), for: .touchUpInside)
    }
    
    private func setupBinding() {
        viewModel.onLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.contentView.loader.startAnimating() : self?.contentView.loader.stopAnimating()
            }
        }
        
        viewModel.onNotify = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlertOk(title: L10n.Message.Notify.title, message: message)
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlertOk(title: L10n.Message.Error.title, message: message)
            }
        }
    }
    
    // MARK: - Action
    
    @objc private func formatPhoneNumber(_ textField: UITextField) {
        let formattedNumber = viewModel.formatPhoneNumber(contentView.phoneNumberTextField.text)
        contentView.phoneNumberTextField.text = formattedNumber
    }
    
    @objc private func getCodeButtonTapped() {
        viewModel.submitPhoneNumber(contentView.phoneNumberTextField.text)
    }
}
