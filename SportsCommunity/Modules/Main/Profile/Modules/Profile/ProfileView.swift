//
//  ProfileView.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 24.01.2025.
//

import SwiftUI
import UIKit
import SnapKit

final class ProfileView: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    internal let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        imageView.image = UIImage(systemName: "person.fill")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        )
        return imageView
    }()
    
    internal let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "Имя Фамилия"
        return label
    }()
    
    internal let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .center
        label.text = "Номер телефона"
        return label
    }()
    
    private let settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    private(set) lazy var loader: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(imageView)
        imageView.addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(phoneLabel)
        addSubview(settingsTableView)
        addSubview(loader)

        setupConstraints()
    }
    
    private func setupConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
        
        settingsTableView.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        loader.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
}

#Preview {
    ProfileView().showLivePreview()
}

