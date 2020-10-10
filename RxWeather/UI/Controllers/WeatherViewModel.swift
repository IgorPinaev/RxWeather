//
//  WeatherViewModel.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 10.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import RxSwift
import RxCocoa

class WeatherViewModel {
    private let apiController = ApiController()
    
    struct Output {
        let tableData: Driver<Event<OneCallResponse>>
    }
    
    func configure() -> Output {
        let tableData = apiController.loadData(with: OneCallResponse.self, endpoint: OpenWeather.oneCall(lat: 51.51, lon: -0.13))
            .materialize()
            .asDriver(onErrorJustReturn: .error(ApiError.unknownError))
        
        return Output(tableData: tableData)
    }
}
