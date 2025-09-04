//
//  EventsView.swift
//  ApplicationName
//
//  Created by Илья Макаров on 24.01.2025
//

import SwiftUI
import UIKit
import SnapKit

class EventsListView: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controls
    
    let dataPickerScroll = UIDataPickerScroll()
    
    let tableViewEvents: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
        return table
    }()
    
    private(set) lazy var loader: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()

    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .white

        addSubview(dataPickerScroll)
        addSubview(tableViewEvents)
        addSubview(loader)
    }
    
    private func setupConstraints() {
        dataPickerScroll.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        tableViewEvents.snp.makeConstraints { make in
            make.top.equalTo(dataPickerScroll.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        loader.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
}

#Preview {
    EventsListView().showLivePreview()
}
