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
        
        let input = FindCityViewModel.Input(searchSignal: searchSignal)
        
        let output = viewModel.configure(with: input)
        
        output.tableData
            .drive(customView.tableView.rx.items(cellIdentifier: FindCityCell.reuseId, cellType: FindCityCell.self)) { $2.fill(city: $1) }
        .disposed(by: disposeBag)
    }
}
