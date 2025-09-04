//
//  EventsViewController.swift
//  ApplicationName
//
//  Created by Илья Макаров on 24.01.2025
//

import UIKit

final class EventsListViewController: UIViewController {
    
    // MARK: - Property
    
    private let contentView = EventsListView()
    private let viewModel: EventsListViewModel
    
    // MARK: - Init
    
    init(viewModel: EventsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(String(describing: type(of: self))) deinitialized")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.tableViewEvents.dataSource = self
        contentView.tableViewEvents.delegate = self
        contentView.dataPickerScroll.delegate = self
        
        setupTarget()
        setupBinding()
        
        contentView.dataPickerScroll.setDate(viewModel.selectedDate)
        
        viewModel.loadEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Setup
    
    private func setupTarget() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addEvent)
        )
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
        
        self.viewModel.onLoaded = { [weak self] events in
            DispatchQueue.main.async {
                self?.contentView.tableViewEvents.reloadData()
            }
        }
    }
    
    // MARK: Methods
    
    public func notifyEventCreate(_ event: Event.View) {
        viewModel.events.append(event)
    }
    
    public func updateEvent(_ event: Event.Edit) {
        viewModel.updateEvent(event)
        
        if let row = viewModel.events.firstIndex(where: { $0.id == event.id }), row != 0 {
            let indexPath = IndexPath(row: row, section: 0)
            contentView.tableViewEvents.reloadRows(at: [indexPath], with: .automatic)
        } else {
            contentView.tableViewEvents.reloadData()
        }
    }
    
    private func editEvent(_ event: Event.View) {
        viewModel.editEvent(event)
    }
    
    private func removeEvent(id: Int, completion: @escaping () -> Void) {
        viewModel.removeEvent(id: id, completion: completion)
    }
    
    private func parseDate(from string: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH:mm"
        return df.date(from: string)
    }
    
    private var filteredEvents: [Event.View] {
        return viewModel.events.filter {
            Calendar.current.isDate($0.date, inSameDayAs: viewModel.selectedDate)
        }
    }
    
    private func updateBackgroundView(for tableView: UITableView, isEmpty: Bool) {
        if isEmpty {
            let containerView = UIView(frame: tableView.bounds)
            
            let messageLabel = UILabel()
            messageLabel.text = L10n.Main.Events.TableView.notFound
            messageLabel.textAlignment = .center
            messageLabel.textColor = .gray
            messageLabel.font = .systemFont(ofSize: 16, weight: .medium)
            messageLabel.numberOfLines = 0
            
            containerView.addSubview(messageLabel)
            messageLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
            }
            
            tableView.backgroundView = containerView
        } else {
            contentView.tableViewEvents.backgroundView = nil
        }
    }
}

extension EventsListViewController {
    @objc private func addEvent(){
        viewModel.createEvent()
    }
}

extension EventsListViewController: UIDataPickerScrollDelegate {
    func didChangeDate(_ date: Date) {
        viewModel.selectedDate = date
        contentView.tableViewEvents.reloadData()
    }
}

extension EventsListViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = filteredEvents.count
        updateBackgroundView(for: tableView, isEmpty: count == 0)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = filteredEvents[indexPath.row]
        let dateString = event.date.toString(format: "d MMM, yyyy, HH:mm")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        content.text = event.name
        content.secondaryText = """
        \(L10n.Main.Events.Cell.Content.SecondaryText.date): \(dateString)
        \(L10n.Main.Events.Cell.Content.SecondaryText.address): \(event.address)
        \(L10n.Main.Events.Cell.Content.SecondaryText.participants): \(event.participants)/\(event.maxParticipants)
        \(L10n.Main.Events.Cell.Content.SecondaryText.sportType): \(event.sportType.title)
        """
        
        cell.contentConfiguration = content
        
        return cell
    }
}


extension EventsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let eventToDelete = filteredEvents[indexPath.row]
            self.removeEvent(id: eventToDelete.id) {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = viewModel.events[indexPath.row]
        self.viewModel.editEvent(event)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
