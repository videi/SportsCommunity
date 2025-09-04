//
//  EventEditorViewController.swift
//  ApplicationName
//
//  Created by Илья Макаров on 12.08.2025
//

import UIKit

final class EventEditorViewController: UIViewController {
    
    // MARK: - Property
    
    private let contentView = EventEditorView()
    private let viewModel: EventEditorViewModel
    private let mode: EventEditorMode
    private var event: Event.View?
    
    // MARK: - Init
    
    init(viewModel: EventEditorViewModel, mode: EventEditorMode) {
        self.viewModel = viewModel
        self.mode = mode
        
        if case let .edit(event) = mode {
            self.event = event
        }
        
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
        setupNavigationButtons()
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupTarget() {
        contentView.getSubviews(of: UITextField.self).forEach { $0.delegate = self }
        contentView.dateField.enableDismissKeyboardOnTap(in: contentView)
    }
    
    private func setupBinding() {
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
    }
    
    private func setupNavigationButtons() {
        
        navigationItem.largeTitleDisplayMode = .never
        
        switch mode {
        case .create:
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: L10n.Button.create,
                style: .done,
                target: self,
                action: #selector(createTapped)
            )
        case .edit:
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: L10n.Button.done,
                style: .done,
                target: self,
                action: #selector(saveTapped)
            )
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: L10n.Button.cancel,
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
    }
    
    private func setupUI() {
        contentView.sportPickerViewField.setItems(SportType.allCases.map({$0.title}))
        
        switch mode {
        case .create:
            title = L10n.Main.Events.Create.title
        case .edit(let event):
            title = event.name
            contentView.nameTextField.isHidden = true
            contentView.addressTextField.text = event.address
            contentView.maxParticipantsTextField.text = "\(event.maxParticipants)"
            contentView.dateField.date = event.date
            if let sport = SportType.allCases.first(where: { $0 == event.sportType }) {
                contentView.sportPickerViewField.setSelectedItem(sport.title)
            }
        }
    }
    
    // MARK: - Action

    @objc private func createTapped() {
        
        guard let sport = SportType.allCases.first(where: { $0.title == contentView.sportPickerViewField.selectedItem }),
              let name = contentView.nameTextField.text, !name.isEmpty,
              let maxParticipants = contentView.maxParticipantsTextField.text.flatMap(Int.init),
              let date = contentView.dateField.date,
              let address = contentView.addressTextField.text, !address.isEmpty
        else {
            showAlertOk(title: L10n.Message.Valid.title, message: L10n.Message.Events.Edit.notvalid)
            return
        }
        
        let createEvent = Event.Create(name: name,
                                       maxParticipants: maxParticipants,
                                       date: date,
                                       address: address,
                                       sportType: sport)
        
        viewModel.add(event: createEvent)
    }
    
    @objc private func saveTapped() {
        guard let idEvent = event?.id else {
            print("id event is nil")
            self.showAlertOk(title: L10n.Message.Error.title, message: L10n.Message.Events.Edit.failure)
            return
        }
        
        guard let sport = SportType.allCases.first(where: { $0.title == contentView.sportPickerViewField.selectedItem }),
              let maxParticipants = contentView.maxParticipantsTextField.text.flatMap(Int.init),
              let date = contentView.dateField.date,
              let address = contentView.addressTextField.text, !address.isEmpty
        else {
            showAlertOk(title: L10n.Message.Valid.title, message: L10n.Message.Events.Edit.notvalid)
            return
        }
        
        let editEvent = Event.Edit(id: idEvent,
                                       maxParticipants: maxParticipants,
                                       date: date,
                                       address: address,
                                       sportType: sport)
        viewModel.update(event: editEvent)
    }
    
    @objc private func cancelTapped() {
        viewModel.cancel()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension EventEditorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
