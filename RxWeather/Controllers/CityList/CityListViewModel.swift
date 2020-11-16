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
    private let disposeBag = DisposeBag()
    
    struct Input {
        let itemSelectedSignal: Signal<IndexPath>
    }
    
    struct Output {
        let tableData: Driver<[City]>
//        let selectedItem: Signal<City?>
    }
    
    func configure(with input: Input) -> Output {
        let tableData = FetchedResultsService<City>.fetchObjects(sortDescriptors: [NSSortDescriptor(key: "name", ascending: false)])
            .share(replay: 1)
        
        input.itemSelectedSignal
            .asObservable()
            .withLatestFrom(tableData) { ($0, $1) }
            .bind(to: Binder(self, binding: { (base, result) in
                let (indexPath, cities) = result
                
//                CoreDataService.instance.context.delete(cities[indexPath.row])
//                CoreDataService.instance.saveContext()
            }))
            .disposed(by: disposeBag)
        
        let tableDataDriver = tableData
            .asDriver(onErrorJustReturn: [])
        
        return Output(tableData: tableDataDriver)
    }
}
