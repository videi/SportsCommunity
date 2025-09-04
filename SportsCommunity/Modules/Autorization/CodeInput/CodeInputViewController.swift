//
//  CodeViewController.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 07.11.2024.
//

import UIKit
import SnapKit
import SwiftUI

final class CodeInputViewController : UIViewController {
    
    // MARK: - Property
    
    private let contentView = CodeInputView()
    private let viewModel : CodeInputViewModel
    
    // MARK: - Init
    
    init(viewModel: CodeInputViewModel) {
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
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.startTimer()
    }
    
    // MARK: - Setup
    
    private func setupTarget() {
        contentView.getCodeButton.addTarget(self, action: #selector(getCodeButtonTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        
        contentView.codeInput.onComplete = { code in
            print("Code \(code)")
            self.viewModel.checkCode(code)
        }
        
        viewModel.onLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.contentView.loader.startAnimating() : self?.contentView.loader.stopAnimating()
            }
        }
        
        viewModel.onRemainingSecondsUpdate = { [weak self] seconds in
            guard let self = self else { return }
            if seconds > 0 {
                if self.contentView.getCodeButton.isHidden == false {
                    self.contentView.timerLabel.isHidden = false
                    self.contentView.getCodeButton.isHidden = true
                }
                self.contentView.timerLabel.text = "\(L10n.Message.CodeInput.notify) \(seconds) \(L10n.Message.CodeInput.Notify.sec)"
            } else {
                self.contentView.timerLabel.isHidden = true
                self.contentView.getCodeButton.isHidden = false
            }
        }
        
        viewModel.onNotify = { [weak self] message, completion in
            DispatchQueue.main.async {
                self?.showAlertOk(title: L10n.Message.Notify.title, message: message, completion: completion)
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlertOk(title: L10n.Message.Error.title, message: message)
            }
        }
    }
    
    // MARK: - Action
    
    @objc private func getCodeButtonTapped() {
        viewModel.getCodeAgain()
    }
}
