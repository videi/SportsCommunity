//
//  ProfileEditViewController.swift
//  ApplicationName
//
//  Created by Илья Макаров on 14.08.2025
//

import UIKit
import PhotosUI

final class ProfileEditViewController: UIViewController {
    
    // MARK: - Property
    
    private let contentView = ProfileEditView()
    private let viewModel: ProfileEditViewModel
    
    // MARK: - Init
    
    init(viewModel: ProfileEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewModel.onError = nil
        viewModel.onNotify = nil
        viewModel.onLoading = nil
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupBinding()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupData(user: viewModel.user)
    }
    
    // MARK: - Setup
    
    private func setupTarget() {
        contentView.getSubviews(of: UITextField.self).forEach { $0.delegate = self }
        contentView.birthDateField.enableDismissKeyboardOnTap(in: contentView)
        contentView.logoutButton.addTarget(self, action: #selector(ProfileEditViewController.exitProfile), for: .touchUpInside)
        contentView.editAvatarButton.addTarget(self, action: #selector(editProfileAvatar), for: .touchUpInside)
    }
    
    private func setupBinding() {
        viewModel.onLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.contentView.loader.startAnimating() : self?.contentView.loader.stopAnimating()
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlertOk(title: L10n.Message.Error.title, message: message)
            }
        }
        
        viewModel.onNotify = { [weak self] message, completion in
            DispatchQueue.main.async {
                self?.showAlertOk(title: L10n.Message.Notify.title, message: message)
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: L10n.Button.done,
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: L10n.Button.cancel,
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
    }
    
    private func setupData(user: User) {
        self.contentView.nameTextField.text = user.name
        self.contentView.surnameTextField.text = user.surname
        self.contentView.emailTextField.text = user.email
        self.contentView.birthDateField.date = user.birthday
    }
    
    // MARK: - Methods
    
    private func setAvatar(image: UIImage) {
        //TODO:Написать вставку картинку в ui control
        //Нужно обрезать картинку под круг
        contentView.profileIconImageView.image = image//.withConfiguration(UIImage.SymbolConfiguration(pointSize: 40, weight: .regular))
    }
}

extension ProfileEditViewController {
    
    @objc private func editProfileAvatar() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func saveTapped() {
        viewModel.save(name: contentView.nameTextField.text ?? "",
                       surname: contentView.surnameTextField.text ?? "",
                       birthday: contentView.birthDateField.dateString ?? "",
                       email: contentView.emailTextField.text ?? "")
    }
    
    @objc func cancelTapped() {
        viewModel.cancel()
    }
    
    @objc func exitProfile() {
        showAlert(title: .none,
                  message: L10n.Message.Profile.Exit.question,
                  actions: [UIAlertAction(title: L10n.Alert.Action.yes, style: .default) { [weak self] action in
            self?.viewModel.exitProfile()
        }, UIAlertAction(title: L10n.Alert.Action.no, style: .cancel)])
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ProfileEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileEditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider else { return }
        
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self, let selectedImage = image as? UIImage else { return }
                
                DispatchQueue.main.async {
                    self.setAvatar(image: selectedImage)
                }
            }
        }
    }
}
