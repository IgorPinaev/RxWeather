//
//  WeatherController.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 06.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class WeatherController: UIViewController {
    private let customView = WeatherView()
    private let viewModel = WeatherViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRx()
    }
}
private extension WeatherController {
    func configureRx() {
        let refreshSignal = customView.refreshControl.rx
            .controlEvent(.primaryActionTriggered)
            .asSignal()
        
        let input = WeatherViewModel.Input(refreshControlSignal: refreshSignal)
        
        let output = viewModel.configure(with: input)
        
        output.tableData
            .compactMap{$0.error}
            .drive(onNext: {print($0)})
            .disposed(by: disposeBag)
        
        let dataSource = getDataSource()
        
        customView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        output.tableData
            .compactMap { (response) -> [MultipleSectionModel]? in
                guard let element = response.element else { return nil }
                
                return [
                    .todaySection(title: "Today", response: [
                        .currentWeather(city: "London", desc: element.current.weather.first?.description ?? "", temp: element.current.temp.intDesc ?? ""),
                        .hourlyWeather(hourly: element.hourly)
                    ]),
                    .dailySection(title: "Daily", dailyData: element.daily.map({ SectionItem.dailyWeather(daily: $0)}))
                ]
        }
        .drive(customView.tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        output.isLoading
            .drive(customView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    func getDataSource() -> RxTableViewSectionedReloadDataSource<MultipleSectionModel> {
        return RxTableViewSectionedReloadDataSource<MultipleSectionModel>(
            configureCell: { dataSource, table, idxPath, _ in
                switch dataSource[idxPath] {
                case let .currentWeather(city: city, desc: desc, temp: temp):
                    let cell = table.dequeueReusableCell(withIdentifier: WeatherCurrentCell.reuseId) as! WeatherCurrentCell
                    cell.fill(city: city, desc: desc, temp: temp)
                    return cell
                case let .hourlyWeather(hourly: hourly):
                    let cell = table.dequeueReusableCell(withIdentifier: WeatherHourlyCell.reuseId) as! WeatherHourlyCell
                    cell.fill(hourlyData: hourly)
                    return cell
                    
                case let .dailyWeather(daily: daily):
                    let cell = table.dequeueReusableCell(withIdentifier: WeatherDailyCell.reuseId) as! WeatherDailyCell
                    cell.fill(weather: daily)
                    return cell
                }
        },
            titleForHeaderInSection: { dataSource, index in
                let section = dataSource[index]
                return section.title
        }
        )
    }
}
extension WeatherController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 1 ? 80 : UITableView.automaticDimension
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
