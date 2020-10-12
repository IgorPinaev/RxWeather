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
    
    struct Input {
        let refreshControlSignal: Signal<Void>
    }
    
    struct Output {
        let tableData: Driver<Event<OneCallResponse>>
        let isLoading: Driver<Bool>
    }
    
    func configure(with input: Input) -> Output {
        let startLoadingData = input.refreshControlSignal
            .startWith(())
            .asObservable()
            .share()
        
        let didRecieveResponse = startLoadingData
            .flatMapLatest({ [weak self] _ -> Observable<OneCallResponse> in
                guard let self = self else { throw ApiError.unknownError }
                return self.apiController.loadData(with: OneCallResponse.self, endpoint: OpenWeather.oneCall(lat: 51.51, lon: -0.13))
            })
        
        let tableData = didRecieveResponse
            .materialize()
            .asDriver(onErrorJustReturn: .error(ApiError.unknownError))
        
        let isLoading = Observable.merge(startLoadingData.map{true}, didRecieveResponse.map{ _ in false })
            .asDriver(onErrorJustReturn: false)
        
        return Output(tableData: tableData, isLoading: isLoading)
    }
}
