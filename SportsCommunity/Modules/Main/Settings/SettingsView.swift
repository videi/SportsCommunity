//
//  SettingsView.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 03.07.2025.
//

import SwiftUI
import UIKit
import SnapKit

final class SettingsView : UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controls

    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .white
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        
    }
    
    private func setupConstraints() {
        
    }
}

#Preview {
    SettingsView().showLivePreview()
}
