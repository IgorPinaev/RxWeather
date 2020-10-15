//
//  OpenWeather.swift
//  RxWeather
//
//  Created by Игорь on 07.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import Foundation

enum OpenWeather {
    case find(_ city: String)
    case oneCall(lat: Double, lon: Double)
}
extension OpenWeather: EndpointProtocol {
    var baseUrl: String {
        return "https://api.openweathermap.org/data/2.5/"
    }
    
    var path: String {
        switch self {
        case .find(_):
            return "find"
        case .oneCall(lat: _, lon: _):
            return "onecall"
        }
    }
    
    var params: [String : String] {
        var params = ["appid": "e382f69da8950542f476171cc68678de", "lang": "ru", "units": "metric"]
        
        switch self {
        case let .find(city):
            params["q"] = city
        case let .oneCall(lat: lat, lon: lon):
            params["lat"] = "\(lat)"
            params["lon"] = "\(lon)"
        }
        
        return params
    }
}
