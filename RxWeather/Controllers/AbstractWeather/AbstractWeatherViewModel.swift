//
//  AbstractWeatherViewModel.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 16.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import RxDataSources
import RxCocoa

class AbstractWeatherViewModel {
    let apiController = ApiController()
    
    struct Input {
        let refreshControlSignal: Signal<Void>
    }
    
    func getSections(response: OneCallResponse, name: String?) -> [MultipleSectionModel] {
        return [.todaySection(title: "Today", response: [
            .currentWeather(city: name ?? "", desc: response.current.weather.first?.description ?? "", temp: response.current.temp.intDesc ?? ""),
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
