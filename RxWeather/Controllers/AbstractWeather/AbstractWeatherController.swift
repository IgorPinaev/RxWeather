//
//  AbstractWeatherController.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 16.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift

class AbstractWeatherController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRx()
    }
    
    func configureRx() {}
    
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
                    cell.fill(dailyData: daily)
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
extension AbstractWeatherController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 && indexPath.row == 1 ? 80 : UITableView.automaticDimension
    }
}
