//
//  WeatherData.swift
//  RxWeather
//
//  Created by Игорь on 07.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import Foundation

struct WeatherHourlyData: Decodable {
    let dt: Date
    let temp: Double
    let feelsLike: Double
    let pressure: Double
    let humidity: Double
    let windSpeed: Double
    let weather: [Weather]
}
