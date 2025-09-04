//
//  SplashScreenViewController.swift
//  ApplicationName
//
//  Created by Илья Макаров on 14.02.2025
//

import UIKit

final class SplashScreenViewController: UIViewController {
    
    // MARK: - Property
    
    private let contentView = SplashScreenView()
    private let viewModel: SplashScreenViewModel
    
    // MARK: - Init
    
    init(viewModel: SplashScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupBinding()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewModel.checkNetworkConnection()
        }
    }
    
    // MARK: - Setup
    
    private func setupTarget() {
        
    }
    
    private func setupBinding() {
        
    }
    
    // MARK: - Action
}
