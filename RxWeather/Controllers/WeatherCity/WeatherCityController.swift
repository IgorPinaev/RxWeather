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
    
    var city: WeatherCity?
    
    override func loadView() {
        view = customView
    }
    
    override func configureRx() {
        configureNavigationController()
        
        let refreshSignal = customView.refreshControl.rx
            .controlEvent(.valueChanged)
            .asSignal()
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(to: Binder(self, binding: { (self, _) in
                self.dismiss(animated: true)
            }))
            .disposed(by: disposeBag)
        
        let addButtonSignal = navigationItem.rightBarButtonItem?.rx.tap
            .asSignal()
        
        let input = WeatherCityViewModel.Input(refreshControlSignal: refreshSignal, addButtonSignal: addButtonSignal)
        
        viewModel.city = city
        
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
        
        output.additionCity?
            .emit(to: Binder(self, binding: { (self, _) in
                self.dismiss(animated: true)
            }))
            .disposed(by: disposeBag)
        
        if let rightBarButtonItem = navigationItem.rightBarButtonItem {
            output.showAddLocalButton
                .drive(rightBarButtonItem.rx.isEnabled)
                .disposed(by: disposeBag)
        }
    }
}
private extension WeatherCityController {
    func configureNavigationController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить", style: .done, target: self, action: nil)
    }
}
