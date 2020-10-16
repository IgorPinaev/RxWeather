//
//  WeatherLocationController.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 06.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherLocationController: AbstractWeatherController {
    private let customView = WeatherLocationView()
    private let viewModel = WeatherLocationViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = customView
    }
    
    override func configureRx() {
        let refreshSignal = customView.refreshControl.rx
            .controlEvent(.valueChanged)
            .asSignal()
        
        let input = WeatherLocationViewModel.Input(refreshControlSignal: refreshSignal)
        
        let output = viewModel.configure(with: input)
        
        output
            .error
            .emit(to: Binder(self, binding: { (self, error) in
                self.show(error)
            }))
            .disposed(by: disposeBag)
        
        output.showSettingsLink
            .drive(customView.linkToSettingsView.rx.isHidden)
            .disposed(by: disposeBag)
        
        customView.settingsButton.rx
            .tap
            .bind(onNext: {
                if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            })
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
