//
//  OneCallResponse.swift
//  RxWeather
//
//  Created by Игорь on 07.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import Foundation

struct OneCallResponse: Decodable {
    let lat: Double
    let lon: Double
    let current: WeatherHourlyData
    let hourly: [WeatherHourlyData]
    let daily: [WeatherDailyData]
}
