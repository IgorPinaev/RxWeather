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
    let apiService = ApiService()

    func getSections(response: OneCallResponse, name: String?) -> [WeatherSectionModel] {
        return [.todaySection(title: "Today", response: [
            .currentWeather(city: name ?? "", desc: response.current.weather.first?.description ?? "", temp: response.current.temp.intDesc ?? ""),
            .hourlyWeather(hourly: response.hourly)
        ]),
        .dailySection(title: "Daily", dailyData: response.daily.map({ WeatherSectionItem.dailyWeather(daily: $0)}))]
    }
}

enum WeatherSectionModel {
    case todaySection(title: String, response: [WeatherSectionItem])
    case dailySection(title: String, dailyData: [WeatherSectionItem])
}

enum WeatherSectionItem {
    case currentWeather(city: String, desc: String, temp: String)
    case hourlyWeather(hourly: [WeatherHourlyData])
    case dailyWeather(daily: WeatherDailyData)
}

extension WeatherSectionModel: SectionModelType {
    typealias Item = WeatherSectionItem
    
    var items: [WeatherSectionItem] {
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
    
    init(original: WeatherSectionModel, items: [Item]) {
        switch original {
        case let .todaySection(title: title, response: _):
            self = .todaySection(title: title, response: items)
        case .dailySection(title: let title, dailyData: _):
            self = .dailySection(title: title, dailyData: items)
        }
    }
}
