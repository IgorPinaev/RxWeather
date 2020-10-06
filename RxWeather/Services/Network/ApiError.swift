//
//  ApiError.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 06.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import Foundation

enum ApiError: LocalizedError {
    case invalidURL
    case dataNil
    case decodingError
    case unknownError
    
//    var errorDescription: String? {
//        switch self {
//        default:
//            return nil
//        }
//    }
}
