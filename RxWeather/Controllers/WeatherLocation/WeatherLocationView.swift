//
//  WeatherLocationView.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 10.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit

class WeatherLocationView: UIView {
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    let linkToSettingsView = UIView()
    let settingsButton = UIButton()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension WeatherLocationView {
    func configureView() {
        backgroundColor = .white
        
        setupTable()
        setupLinkToSettingsView()
    }
    
    func setupTable() {
        addSubview(tableView)
        tableView.fillParent()
        tableView.refreshControl = refreshControl
        
        tableView.register(WeatherCurrentCell.self, forCellReuseIdentifier: WeatherCurrentCell.reuseId)
        tableView.register(WeatherHourlyCell.self, forCellReuseIdentifier: WeatherHourlyCell.reuseId)
        tableView.register(WeatherDailyCell.self, forCellReuseIdentifier: WeatherDailyCell.reuseId)
        
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
    }
    
    func setupLinkToSettingsView() {
        linkToSettingsView.backgroundColor = .green
        addSubview(linkToSettingsView)
        linkToSettingsView.fillParent()
        
        linkToSettingsView.addSubview(settingsButton)
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.setTitle("В настройки", for: .normal)
        settingsButton.setTitleColor(.black, for: .normal)
        
        NSLayoutConstraint.activate([
            settingsButton.centerYAnchor.constraint(equalTo: linkToSettingsView.centerYAnchor),
            settingsButton.centerXAnchor.constraint(equalTo: linkToSettingsView.centerXAnchor)
        ])
    }
}
