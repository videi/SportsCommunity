//
//  UIMonthDay.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 04.07.2025.
//

import UIKit
import SnapKit

protocol UIDataPickerScrollDelegate: AnyObject {
    func didChangeDate(_ date: Date)
}

final class UIDataPickerScroll: UIView, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: UIDataPickerScrollDelegate?
    
    private let calendar = Calendar.current
    private var currentMonthDate = Date()
    private var daysInMonth: [Int] = []
    private var selectedDay: Int = 1
    private var selectedDayValue: Int = 1
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()

    private let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = Asset.Colors.Button.bgColor.color
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()

    private let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = Asset.Colors.Button.bgColor.color
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    
    private lazy var dayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: "DayCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTarget()
        setupConstraints()
        updateMonthDisplay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(leftButton)
        addSubview(monthLabel)
        addSubview(rightButton)
        addSubview(dayCollectionView)
    }

    private func setupTarget() {
        leftButton.addTarget(self, action: #selector(prevMonth), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        monthLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()      
            make.top.equalToSuperview().offset(8)
        }

        rightButton.snp.makeConstraints { make in
            make.leading.equalTo(monthLabel.snp.trailing).offset(8)
            make.centerY.equalTo(monthLabel)
        }

        leftButton.snp.makeConstraints { make in
            make.trailing.equalTo(monthLabel.snp.leading).offset(-8)
            make.centerY.equalTo(monthLabel)
        }
        
        dayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().offset(8)
            make.height.equalTo(60)
            make.bottom.equalToSuperview()
        }
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentMonthDate) {
            currentMonthDate = newDate
            updateMonthDisplay()
            updateDaysDisplay()
            notifyDateChange()
        }
    }
    
    private func updateMonthDisplay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        formatter.locale = .current
        monthLabel.text = formatter.string(from: currentMonthDate).capitalized
        
        let range = calendar.range(of: .day, in: .month, for: currentMonthDate)!
        daysInMonth = Array(range)
        dayCollectionView.reloadData()
        
        if let index = daysInMonth.firstIndex(of: selectedDay) {
            DispatchQueue.main.async {
                self.dayCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    private func updateDaysDisplay() {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentMonthDate)!
        daysInMonth = Array(range)
        
        // Обновляем selectedDay с учетом выбранного ранее
        let lastDay = range.upperBound - 1
        selectedDay = min(selectedDayValue, lastDay)  // сохраняем максимально допустимый день
        dayCollectionView.reloadData()
    }
    
    private func notifyDateChange() {
        var components = calendar.dateComponents([.year, .month], from: currentMonthDate)
        components.day = selectedDay
        if let date = calendar.date(from: components) {
            delegate?.didChangeDate(date)
        }
    }
    
    public func setDate(_ date: Date) {
            currentMonthDate = date
            let day = calendar.component(.day, from: date)
            selectedDay = day
            selectedDayValue = day
            
            updateMonthDisplay()
            updateDaysDisplay()
            
            if let index = daysInMonth.firstIndex(of: day) {
                DispatchQueue.main.async {
                    self.dayCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
                }
            }
        }
}

extension UIDataPickerScroll {
    @objc private func nextMonth() {
        changeMonth(by: 1)
    }

    @objc private func prevMonth() {
        changeMonth(by: -1)
    }
}

extension UIDataPickerScroll: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        daysInMonth.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
        let day = daysInMonth[indexPath.item]
        cell.configure(day: day, isSelected: day == selectedDay, monthDate: currentMonthDate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDay = daysInMonth[indexPath.item]
        selectedDayValue = selectedDay
        dayCollectionView.reloadData()
        notifyDateChange()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 40, height: 40)
    }
}

final class DayCell: UICollectionViewCell {
    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private let dayBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        return view
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTarget()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() { 
        contentView.addSubview(weekdayLabel)
        contentView.addSubview(dayBackgroundView)
        dayBackgroundView.addSubview(dayLabel)
    }
    
    private func setupTarget() {
        
    }
    
    private func setupConstraints() {
        weekdayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        dayBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(weekdayLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(day: Int, isSelected: Bool, monthDate: Date) {
        // День недели
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: monthDate)
        components.day = day
        guard let date = calendar.date(from: components) else { return }
        
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "E"
        let weekday = formatter.string(from: date).capitalized
        weekdayLabel.text = weekday
        
        // Цифра дня
        dayLabel.text = "\(day)"
        
        // Стилизация
        if isSelected {
            dayBackgroundView.backgroundColor = Asset.Colors.Button.bgColor.color
            dayLabel.textColor = Asset.Colors.Button.textColor.color
            dayBackgroundView.layer.borderColor = Asset.Colors.Button.bgColor.color.cgColor
        } else {
            dayBackgroundView.backgroundColor = .clear
            dayLabel.textColor = .black
            dayBackgroundView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
}
