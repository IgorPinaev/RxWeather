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
import RxDataSources

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
        
        itemSelectedSignal
            .emit(to: Binder(self, binding: { (self, indexPath) in
                self.customView.tableView.deselectRow(at: indexPath, animated: true)
            }))
            .disposed(by: disposeBag)
        
        let input = CityListViewModel.Input(itemSelectedSignal:itemSelectedSignal)
        
        let output = viewModel.configure(with: input)
        
        output.tableData
            .drive(customView.tableView.rx.items(dataSource: getDataSource()))
            .disposed(by: disposeBag)
        
        output.selectedItem
            .emit(to: Binder(self, binding: { (self, city) in
                if let city = city {
                    
                } else {
                    let controller = FindCityController()
                    
                    let destinationNavigationController = UINavigationController()
                    destinationNavigationController.setViewControllers([controller], animated: false)
                    self.present(destinationNavigationController, animated: true)
                }
            }))
            .disposed(by: disposeBag)
    }
    
    func getDataSource() -> RxTableViewSectionedReloadDataSource<CitySectionModel> {
        return RxTableViewSectionedReloadDataSource<CitySectionModel>(
            configureCell: { dataSource, table, idxPath, _ in
                switch dataSource[idxPath] {
                case let .cityItem(city: city):
                    let cell = table.dequeueReusableCell(withIdentifier: CityCell.reuseId) as! CityCell
                    cell.fill(city: city)
                    return cell
                case .addNewItem:
                    return table.dequeueReusableCell(withIdentifier: AddNewCityCell.reuseId)!
                }
            }
        )
    }
}
