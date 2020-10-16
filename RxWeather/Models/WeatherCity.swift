//
//  WeatherCity.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 15.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import Foundation

class WeatherCityList: Decodable {
    let list: [WeatherCity]
}

class WeatherCity: Decodable {
    let id: Int
    let name: String
    let lat: Double
    let lon: Double
    let temp: Double
    let country: String
    let dt: Date
    let weather: [Weather]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        dt = try container.decode(Date.self, forKey: .dt)
        weather = try container.decode([Weather].self, forKey: .weather)
        
        let coordContainer = try container.nestedContainer(keyedBy: CoordCodingKeys.self, forKey: .coord)
        lat = try coordContainer.decode(Double.self, forKey: .lat)
        lon = try coordContainer.decode(Double.self, forKey: .lon)
        
        let countryContainer = try container.nestedContainer(keyedBy: CountryCodingKeys.self, forKey: .sys)
        country = try countryContainer.decode(String.self, forKey: .country)
        
        let mainContainer = try container.nestedContainer(keyedBy: MainCodingKeys.self, forKey: .main)
        temp = try mainContainer.decode(Double.self, forKey: .temp)
    }
}
private extension WeatherCity {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case coord
        case main
        case sys
        case dt
        case weather
    }
    
    enum CoordCodingKeys: String, CodingKey {
        case lat
        case lon
    }
    
    enum MainCodingKeys: String, CodingKey {
        case temp
    }
    
    enum CountryCodingKeys: String, CodingKey {
        case country
    }
}
