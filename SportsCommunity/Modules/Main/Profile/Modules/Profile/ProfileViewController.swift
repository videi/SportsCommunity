//
//  ViewController.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 27.09.2024.
//

import UIKit
import PhotosUI

final class ProfileViewController: UIViewController {
    
    // MARK: - Property
    
    private let contentView = ProfileView()
    private let viewModel : ProfileViewModel
    
    // MARK: - Init
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewModel.onUpdate = nil
        viewModel.onError = nil
        viewModel.onNotify = nil
        viewModel.onLoading = nil
    }
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTarget()
        setupBindings()
        Task { [weak self] in
            await self?.viewModel.loadProfileInfoAsync()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Setup
    
    private func setupTarget() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editProfile))
        navigationItem.title = MainRouteType.profile.title
        navigationItem.largeTitleDisplayMode = .inline
    }
    
    private func setupBindings() {
        viewModel.onLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.contentView.loader.startAnimating() : self?.contentView.loader.stopAnimating()
            }
        }
        
        self.viewModel.onNotify = { [weak self] message, completion in
            DispatchQueue.main.async {
                self?.showAlertOk(title: L10n.Message.Notify.title, message: message)
            }
        }
        
        self.viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlertOk(title: L10n.Message.Error.title, message: message)
            }
        }
        
        self.viewModel.onUpdate = { [weak self] profile in
            DispatchQueue.main.async {
                self?.updateUI(with: profile)
            }
        }
    }
     
    // MARK: - Methods
   
    private func updateUI(with user: User) {
        do {
            contentView.nameLabel.text = "\(user.name ?? "") \(user.surname ?? "")"
            contentView.phoneLabel.text = "\(try user.phone.toPhoneNumber())"
        } catch {
            showAlertOk(title: L10n.Message.Error.title, message: error.localizedDescription)
        }
    }
    
    public func updateUserInfo(user: User) {
        viewModel.user = user
    }
}

extension ProfileViewController {
    
    @objc private func editProfile() {
        viewModel.editProfile()
    }
}
