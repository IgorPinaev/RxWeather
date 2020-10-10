//
//  WeatherController.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 06.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

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
        let output = viewModel.configure()
        
        output.tableData
            .compactMap{$0.error}
            .drive(onNext: {print($0)})
            .disposed(by: disposeBag)
        
        output.tableData
            .compactMap{ $0.element?.daily }
            .drive(customView.tableView.rx.items(cellIdentifier: WeatherDailyCell.reuseId, cellType: WeatherDailyCell.self)) { $2.fill(weather: $1) }
            .disposed(by: disposeBag)
    }
}
//extension WeatherController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let weather = weather {
//            return weather.daily.count + 2
//        }
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCurrentCell.reuseId) as! WeatherCurrentCell
//            let current = weather?.hourly.first
//            cell.fill(city: "London", desc: current?.weather.first?.description ?? "", temp: current?.temp.intDesc ?? "")
//
//            return cell
//        } else if indexPath.row == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherHourlyCell.reuseId) as! WeatherHourlyCell
//            cell.fill(hourlyData: weather?.hourly ?? [])
//
//            return cell
//        }
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDailyCell.reuseId) as! WeatherDailyCell
//        cell.fill(weather: weather!.daily[indexPath.row - 2])
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return indexPath.row == 1 ? 80 : UITableView.automaticDimension
//    }
//}
