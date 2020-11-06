//
//  WeatherCityViewModel.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 15.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import RxSwift
import RxCocoa

class WeatherCityViewModel: AbstractWeatherViewModel {
    var city: WeatherCity?
    
    struct Input {
        let refreshControlSignal: Signal<Void>
        let addButtonSignal: Signal<Void>?
    }
    
    struct Output {
        let tableData: Driver<[MultipleSectionModel]>
        let isLoading: Driver<Bool>
        let error: Signal<Error>
        let showAddLocalButton: Driver<Bool>
    }
    
    func configure(with input: Input) -> Output {
        let startLoadingData = input.refreshControlSignal
            .startWith(())
            .asObservable()
            .share()
        
        let response = startLoadingData
            .flatMapLatest { [weak self] location -> Observable<Event<OneCallResponse>> in
                guard let self = self, let city = self.city else { throw ApiError.unknownError }
                return self.apiController.loadData(with: OneCallResponse.self, endpoint: OpenWeather.oneCall(lat: city.lat, lon: city.lon))
                    .materialize()
            }
            .share()
        
        let error = response
            .compactMap { $0.error }
            .asSignal(onErrorJustReturn: ApiError.unknownError)
        
        let tableData = response
            .compactMap { $0.element }
            .map({ [weak self] in
                return self?.getSections(response: $0, name: self?.city?.name ?? "") ?? []
            })
            .asDriver(onErrorJustReturn: [])
        
        let isLoading = Observable.merge(startLoadingData.map { true }, response.map { _ in false })
            .asDriver(onErrorJustReturn: false)
        
        let showAddLocalButton = Observable.just(city)
            .map{ $0?.id == 1496153 }
            .asDriver(onErrorJustReturn: false)
            
        return Output(tableData: tableData, isLoading: isLoading, error: error, showAddLocalButton: showAddLocalButton)
    }
}
