//
//  CityListViewModel.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 11.11.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import Foundation
import CoreData
import RxCocoa
import RxSwift
import RxDataSources

class CityListViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let itemSelectedSignal: Signal<IndexPath>
    }
    
    struct Output {
        let tableData: Driver<[CitySectionModel]>
        let selectedItem: Signal<City?>
    }
    
    func configure(with input: Input) -> Output {
        let tableData = FetchedResultsService<City>.fetchObjects(sortDescriptors: [NSSortDescriptor(key: "name", ascending: false)])
            .share(replay: 1)
        
        let selectedItem = input.itemSelectedSignal
            .asObservable()
            .withLatestFrom(tableData) { ($0, $1) }
            .map({ (indexPath, cities) -> City? in
                indexPath.section == 0 ? cities[indexPath.row] : nil
            })
            .asSignal(onErrorJustReturn: nil)
        
        let tableDataDriver = tableData
            .map { [weak self] in
                self?.getSections(cities: $0) ?? []
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(tableData: tableDataDriver, selectedItem: selectedItem)
    }
    
    func getSections(cities: [City]) -> [CitySectionModel] {
        return [.citiesSection(cities: cities.map { .cityItem(city: $0) }),
                .addItemSection(items: [.addNewItem])]
    }
}

enum CitySectionModel {
    case citiesSection(cities: [CitySectionItem])
    case addItemSection(items: [CitySectionItem])
}

enum CitySectionItem {
    case cityItem(city: City)
    case addNewItem
}

extension CitySectionModel: SectionModelType {
    typealias Item = CitySectionItem
    
    var items: [CitySectionItem] {
        switch self {
        case .citiesSection(cities: let cities):
            return cities.map { $0 }
        case .addItemSection(items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: CitySectionModel, items: [Item]) {
        switch original {
        case .citiesSection(cities: _):
            self = .citiesSection(cities: items)
        case .addItemSection(items: _):
            self = .addItemSection(items: items)
        }
    }
}
