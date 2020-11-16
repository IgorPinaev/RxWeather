//
//  AbstractWeatherView.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 16.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit

class AbstractWeatherView: UIView {
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        setupTable()
    }
}
private extension AbstractWeatherView {
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
}
