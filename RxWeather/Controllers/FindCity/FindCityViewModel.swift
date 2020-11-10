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
    private let apiService = ApiService()
    
    struct Input {
        let searchSignal: Signal<String?>
        let itemSelectedSignal: Signal<IndexPath>
    }
    
    struct Output {
        let tableData: Driver<[WeatherCity]>
        let error: Signal<Error>
        let selectedItem: Signal<WeatherCity?>
    }
    
    func configure(with input: Input) -> Output {
        let response = input.searchSignal
            .asObservable()
            .compactMap { $0 }
            .flatMapLatest { [unowned self] city -> Observable<Event<WeatherCityList>> in
                return self.apiService.loadData(with: WeatherCityList.self, endpoint: OpenWeather.find(city))
                    .materialize()
            }
            .share()
        
        let error = response
            .compactMap { $0.error }
            .asSignal(onErrorJustReturn: ApiError.unknownError)
        
        let tableData = response
            .compactMap { $0.element?.list }
            .share()

        let selectedItem = input.itemSelectedSignal
            .asObservable()
            .withLatestFrom(tableData) { ($0, $1) }
            .map { $1[$0.row] }
            .asSignal(onErrorJustReturn: nil)
        
        let tableDataDriver = tableData
            .asDriver(onErrorJustReturn: [])
        
        return Output(tableData: tableDataDriver, error: error, selectedItem: selectedItem)
    }
}
