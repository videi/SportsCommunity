//
//  SplashScreenView.swift
//  ApplicationName
//
//  Created by Илья Макаров on 14.02.2025
//

import SwiftUI
import UIKit
import SnapKit

class SplashScreenView: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controls
    
    private(set) lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "НаСпорте"
        label.font = UIFont.systemFont(ofSize: 54, weight: .bold)
        label.textColor = UIColor(hex: "#F2524D")
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Setup
    
    private func setupUI() {
        self.backgroundColor = UIColor(hex: "#6C1C1C")
        
        self.addSubview(logoLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        logoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

#Preview {
    SplashScreenView().showLivePreview()
}
