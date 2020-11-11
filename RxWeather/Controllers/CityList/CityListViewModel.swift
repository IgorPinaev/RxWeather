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

class CityListViewModel {
    struct Output {
        let tableData: Driver<[City]>
//        let selectedItem: Signal<City?>
    }
    
    func configure() -> Output {
        let frcService = configureFrcService()
        
        let data = frcService.getFetchedObjects()
            .asDriver()
        
        return Output(tableData: data)
    }
}
private extension CityListViewModel {
    func configureFrcService() -> FetchedResultsService<City> {
        return FetchedResultsService<City>(delegate: nil, sortDescriptors: [NSSortDescriptor(key: "name", ascending: false)])
    }
}
