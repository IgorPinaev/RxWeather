//
//  WeatherController.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 06.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
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
            .controlEvent(.valueChanged)
            .asSignal()
        
        let input = WeatherViewModel.Input(refreshControlSignal: refreshSignal)
        
        let output = viewModel.configure(with: input)
        
        output
            .error
            .emit(to: Binder(self, binding: { (self, error) in
                self.show(error)
            }))
            .disposed(by: disposeBag)
        
        customView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        output.tableData
            .drive(customView.tableView.rx.items(dataSource: getDataSource()))
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(customView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    func show(_ error: Error) {
        print(error)
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
        return indexPath.section == 0 && indexPath.row == 1 ? 80 : UITableView.automaticDimension
    }
}
