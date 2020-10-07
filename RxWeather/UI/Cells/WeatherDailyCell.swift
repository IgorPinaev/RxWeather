//
//  WeatherDataCell.swift
//  RxWeather
//
//  Created by Игорь on 07.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit

class WeatherDailyCell: AbstractTableViewCell {
    private var dateLabel = UILabel()
    private var tempDayLabel = UILabel()
    private var tempNightLabel = UILabel()
    
    func fill(weather: WeatherDailyData) {
        tempDayLabel.text = weather.temp.day.description
        tempNightLabel.text = weather.temp.night.description
        dateLabel.text = weather.dt.day
    }
    
    override func setupLayouts() {
        setupElement(element: dateLabel, constraints: [
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        setupElement(element: tempDayLabel, constraints: [
            tempDayLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 16),
            tempDayLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor)
        ])
        
        setupElement(element: tempNightLabel, constraints: [
            tempNightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tempNightLabel.leadingAnchor.constraint(equalTo: tempDayLabel.trailingAnchor, constant: 8),
            tempNightLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor)
        ])
    }
}
