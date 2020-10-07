//
//  Double.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 07.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import Foundation

extension Double {
    var intDesc: String? {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0

        return formatter.string(from: NSNumber(value: self))
    }
}
