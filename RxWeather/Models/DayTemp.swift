//
//  DayTemp.swift
//  RxWeather
//
//  Created by Игорь on 07.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import Foundation

struct DayTemp: Decodable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}
