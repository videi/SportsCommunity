//
//  Settings.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 18.01.2025.
//

import Foundation
import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let contentView = SettingsView()
    private let viewModel: SettingsViewModel
    
    // MARK: - Init
    
    init(viewModel: SettingsViewModel) {
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
    }
    
    // MARK: - Setup
    
    private func setupTarget() {
        
    }
    
    private func setupBinding() {
        
    }
    
    // MARK: - Methods
    
}
