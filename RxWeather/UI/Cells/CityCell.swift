//
//  CityCell.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 16.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit

class CityCell: AbstractTableViewCell {
    private var nameLabel = UILabel()
    private var tempLabel = UILabel()
    
    func fill(city: WeatherCity) {
        nameLabel.text = "\(city.name), \(city.country)"
        
        if let temp = city.temp?.intDesc {
            tempLabel.text = "\(temp) °C"
        } else {
            tempLabel.text = nil
        }
    }
    
    func fill(city: City) {
        nameLabel.text = "\(city.name), \(city.country)"
        tempLabel.text = nil
    }
    
    override func setupLayouts() {
        setupElement(element: nameLabel, constraints: [
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        setupElement(element: tempLabel, constraints: [
            tempLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16),
            tempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tempLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor)
        ])
    }
}
