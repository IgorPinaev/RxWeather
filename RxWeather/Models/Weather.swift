//
//  Weather.swift
//  RxWeather
//
//  Created by Игорь on 07.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
}
