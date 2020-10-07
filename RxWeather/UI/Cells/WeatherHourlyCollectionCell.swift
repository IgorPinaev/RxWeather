//
//  WeatherHourlyCollectionCell.swift
//  RxWeather
//
//  Created by Игорь on 07.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit

class WeatherHourlyCollectionCell: UICollectionViewCell {
    static var reuseId: String { String(describing: self) }
    
    private var timeLabel = UILabel()
    private var tempLabel = UILabel()
    
    func fill(hourlyData: WeatherHourlyData, now: Bool) {
        timeLabel.text = now ? "Сейчас" : hourlyData.dt.hour
        tempLabel.text = hourlyData.temp.description
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTimeLabel()
        setupTempLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTimeLabel() {
        addSubview(timeLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
    }
    
    private func setupTempLabel() {
        addSubview(tempLabel)
        
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tempLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            tempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            tempLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            tempLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
