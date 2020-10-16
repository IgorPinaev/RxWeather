//
//  WeatherLocationView.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 10.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit

class WeatherLocationView: AbstractWeatherView {
    let linkToSettingsView = UIView()
    let settingsButton = UIButton()
    
    override func configureView() {
        super.configureView()
        setupLinkToSettingsView()
    }
}
private extension WeatherLocationView {
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
