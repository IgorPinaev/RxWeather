//
//  CityListController.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 11.11.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CityListController: UIViewController {
    private let viewModel = CityListViewModel()
    private let customView = CityListView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRx()
    }
}
private extension CityListController {
    func configureRx() {
        let itemSelectedSignal = customView.tableView.rx.itemSelected
            .asSignal()
        
        let input = CityListViewModel.Input(itemSelectedSignal:itemSelectedSignal)
        
        let output = viewModel.configure(with: input)
        
        output.tableData
            .drive(customView.tableView.rx.items(cellIdentifier: CityCell.reuseId, cellType: CityCell.self)) { $2.fill(city: $1) }
            .disposed(by: disposeBag)
    }
}
