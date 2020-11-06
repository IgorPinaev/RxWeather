//
//  FindCityController.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 16.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FindCityController: UIViewController {
    private let customView = FindCityView()
    private let viewModel = FindCityViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRx()
    }
}
private extension FindCityController {
    func configureRx() {
        let searchSignal = customView.searchBar.rx.text
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: nil)
        
        let itemSelectedSignal = customView.tableView.rx.itemSelected
            .asSignal()
        
        itemSelectedSignal
            .emit(to: Binder(self, binding: { (self, indexPath) in
                self.customView.tableView.deselectRow(at: indexPath, animated: true)
            }))
            .disposed(by: disposeBag)
        
        let input = FindCityViewModel.Input(searchSignal: searchSignal, itemSelectedSignal: itemSelectedSignal)
        
        let output = viewModel.configure(with: input)
        
        output.tableData
            .drive(customView.tableView.rx.items(cellIdentifier: FindCityCell.reuseId, cellType: FindCityCell.self)) { $2.fill(city: $1) }
            .disposed(by: disposeBag)
        
        output
            .error
            .emit(to: Binder(self, binding: { (self, error) in
                self.show(error)
            }))
            .disposed(by: disposeBag)
        
        output.selectedItem
            .compactMap { $0 }
            .emit(to: Binder(self, binding: { (self, weatherCity) in
                let controller = WeatherCityController()
                controller.city = weatherCity
                
                let destinationNavigationController = UINavigationController()
                destinationNavigationController.setViewControllers([controller], animated: false)
                self.present(destinationNavigationController, animated: true)
            }))
            .disposed(by: disposeBag)
    }
}
