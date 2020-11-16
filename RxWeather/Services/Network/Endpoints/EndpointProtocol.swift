//
//  EndpointProtocol.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 06.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

protocol EndpointProtocol {
    var baseUrl: String { get }
    var path: String { get }
    var params: [String: String] { get }
}
