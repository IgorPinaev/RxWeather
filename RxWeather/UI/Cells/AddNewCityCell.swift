//
//  AddNewCityCell.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 16.11.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit

class AddNewCityCell: AbstractTableViewCell {
    private let button = UIButton()
    
    override func setupLayouts() {
        button.setTitle("Добавить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        setupElement(element: button, constraints: [
            button.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
