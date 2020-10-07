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
    private let disposeBag = DisposeBag()
    
    private var weather: OneCallResponse?
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        
        table.register(WeatherCurrentCell.self, forCellReuseIdentifier: WeatherCurrentCell.reuseId)
        table.register(WeatherHourlyCell.self, forCellReuseIdentifier: WeatherHourlyCell.reuseId)
        table.register(WeatherDailyCell.self, forCellReuseIdentifier: WeatherDailyCell.reuseId)
        
        table.tableFooterView = UIView()
        table.allowsSelection = false
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTable()
        loadWeather()
    }
    
    private func setupTable() {
        view.addSubview(tableView)
        tableView.fillParent()
    }
    
    private func loadWeather() {
        ApiController.shared.loadData(with: OneCallResponse.self, endpoint: OpenWeather.oneCall(lat: 51.51, lon: -0.13))
            .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] in
            self?.weather = $0
            self?.tableView.reloadData()
        }, onError: {
            print($0)
        })
        .disposed(by: disposeBag)
    }
}
extension WeatherController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let weather = weather {
            return weather.daily.count + 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCurrentCell.reuseId) as! WeatherCurrentCell
            let current = weather?.hourly.first
            cell.fill(city: "London", desc: current?.weather.first?.description ?? "", temp: current?.temp.intDesc ?? "")
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherHourlyCell.reuseId) as! WeatherHourlyCell
            cell.fill(hourlyData: weather?.hourly ?? [])
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDailyCell.reuseId) as! WeatherDailyCell
        cell.fill(weather: weather!.daily[indexPath.row - 2])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 1 ? 80 : UITableView.automaticDimension
    }
}
