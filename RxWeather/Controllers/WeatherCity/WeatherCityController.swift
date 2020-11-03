//
//  WeatherCityController.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 15.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import RxCocoa

class WeatherCityController: AbstractWeatherController {
    private let customView = AbstractWeatherView()
    private let viewModel = WeatherCityViewModel()
    
    var name: String?
    var lat: Double?
    var lon: Double?
    
    override func loadView() {
        view = customView
    }
    
    override func configureRx() {
        let refreshSignal = customView.refreshControl.rx
            .controlEvent(.valueChanged)
            .asSignal()
        
        let input = WeatherCityViewModel.Input(refreshControlSignal: refreshSignal)
        
        viewModel.name = name
        viewModel.lat = lat
        viewModel.lon = lon
        
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
}
