//
//  WeatherCurrentCell.swift
//  RxWeather
//
//  Created by Игорь on 07.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit

class WeatherCurrentCell: AbstractTableViewCell {
    private var cityLabel = UILabel()
    private var descLabel = UILabel()
    private var tempLabel = UILabel()
    
    func fill(city: String, desc: String, temp: String) {
        cityLabel.text = city
        descLabel.text = desc
        tempLabel.text = temp
    }
    
    override func setupLayouts() {
        setupElement(element: cityLabel, constraints: [
            cityLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        setupElement(element: descLabel, constraints: [
            descLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8),
            descLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        setupElement(element: tempLabel, constraints: [
            tempLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 8),
            tempLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            tempLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
