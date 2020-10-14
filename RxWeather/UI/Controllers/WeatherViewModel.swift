//
//  WeatherViewModel.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 10.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

class WeatherViewModel {
    private let apiController = ApiController()
    
    struct Input {
        let refreshControlSignal: Signal<Void>
    }
    
    struct Output {
        let tableData: Driver<[MultipleSectionModel]>
        let isLoading: Driver<Bool>
        let error: Signal<Error>
    }
    
    func configure(with input: Input) -> Output {
        let startLoadingData = input.refreshControlSignal
            .startWith(())
            .asObservable()
            .share()
        
        let response = startLoadingData
            .flatMapLatest { [weak self] _ -> Observable<Event<OneCallResponse>> in
                guard let self = self else { throw ApiError.unknownError }
                return self.apiController.loadData(with: OneCallResponse.self, endpoint: OpenWeather.oneCall(lat: 51.51, lon: -0.13))
                .materialize()
            }
            .share()
        
        let error = response
            .compactMap { $0.error }
            .asSignal(onErrorJustReturn: ApiError.unknownError)
        
        let tableData = response
            .compactMap { [weak self] response -> [MultipleSectionModel]? in
                guard let element = response.element else { return nil }
                return self?.getSections(response: element)
            }
            .asDriver(onErrorJustReturn: [])

        let isLoading = Observable.merge(startLoadingData.map { true }, response.map { _ in false })
            .asDriver(onErrorJustReturn: false)
        
        return Output(tableData: tableData, isLoading: isLoading, error: error)
    }
}
private extension WeatherViewModel {
    func getSections(response: OneCallResponse) -> [MultipleSectionModel] {
        return [.todaySection(title: "Today", response: [
            .currentWeather(city: "London", desc: response.current.weather.first?.description ?? "", temp: response.current.temp.intDesc ?? ""),
            .hourlyWeather(hourly: response.hourly)
        ]),
         .dailySection(title: "Daily", dailyData: response.daily.map({ SectionItem.dailyWeather(daily: $0)}))]
    }
}

enum MultipleSectionModel {
    case todaySection(title: String, response: [SectionItem])
    case dailySection(title: String, dailyData: [SectionItem])
}

enum SectionItem {
    case currentWeather(city: String, desc: String, temp: String)
    case hourlyWeather(hourly: [WeatherHourlyData])
    case dailyWeather(daily: WeatherDailyData)
}

extension MultipleSectionModel: SectionModelType {
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .todaySection(title: _, response: let items):
            return items.map { $0 }
        case .dailySection(title: _, dailyData: let dailyData):
            return dailyData.map { $0 }
        }
    }
    
    var title: String {
        switch self {
        case .todaySection(title: let title, response: _):
            return title
        case .dailySection(title: let title, dailyData: _):
            return title
        }
    }
    
    init(original: MultipleSectionModel, items: [Item]) {
        switch original {
        case let .todaySection(title: title, response: _):
            self = .todaySection(title: title, response: items)
        case .dailySection(title: let title, dailyData: let dailyData):
            self = .dailySection(title: title, dailyData: dailyData)
        }
    }
}
