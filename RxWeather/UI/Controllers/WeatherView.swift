//
//  WeatherView.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 10.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit

class WeatherView: UIView {
    let tableView = UITableView()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension WeatherView {
    func configureView() {
        backgroundColor = .white
        
        setupTable()
    }
    
    func setupTable() {
        addSubview(tableView)
        tableView.fillParent()
        
        tableView.register(WeatherCurrentCell.self, forCellReuseIdentifier: WeatherCurrentCell.reuseId)
        tableView.register(WeatherHourlyCell.self, forCellReuseIdentifier: WeatherHourlyCell.reuseId)
        tableView.register(WeatherDailyCell.self, forCellReuseIdentifier: WeatherDailyCell.reuseId)
        
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
    }
}
