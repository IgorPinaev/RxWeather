//
//  Weather.swift
//  RxWeather
//
//  Created by Игорь on 07.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import Foundation

struct WeatherResponse: Decodable {
    let id: Int
    let lon: Double
    let lat: Double
    let name: String
//    let weather: [Weather]
//    let main: Main
//    let speed: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        
        case lon = "lon"
        case lat = "lat"
        case name
        
    }
}
