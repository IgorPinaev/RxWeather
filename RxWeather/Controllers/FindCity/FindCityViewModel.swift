//
//  FindCityViewModel.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 16.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import RxSwift
import RxCocoa

class FindCityViewModel {
    private let apiController = ApiController()
    
    struct Input {
        let searchSignal: Signal<String?>
    }
    
    struct Output {
        let tableData: Driver<[WeatherCity]>
        let isLoading: Driver<Bool>
        let error: Signal<Error>
    }
    
    func configure(with input: Input) -> Output {
        let startLoadingData = input.searchSignal
            .asObservable()
            .share()
        
        let response = startLoadingData
            .compactMap { $0 }
            .flatMapLatest { [weak self] city -> Observable<Event<WeatherCityList>> in
                guard let self = self else { throw ApiError.unknownError }
                return self.apiController.loadData(with: WeatherCityList.self, endpoint: OpenWeather.find(city))
                    .materialize()
            }
            .share()
        
        let error = response
            .compactMap {$0.error}
            .asSignal(onErrorJustReturn: ApiError.unknownError)
        
        let tableData = response
            .compactMap { $0.element?.list }
            .asDriver(onErrorJustReturn: [])
        
        let isLoading = Observable.merge(startLoadingData.map { _ in true }, response.map { _ in false })
            .asDriver(onErrorJustReturn: false)
        
        return Output(tableData: tableData, isLoading: isLoading, error: error)
    }
}
