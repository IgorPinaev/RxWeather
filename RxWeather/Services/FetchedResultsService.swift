//
//  FetchResultsService.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 11.11.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import Foundation
import CoreData
import RxCocoa

class FetchedResultsService<T: NSManagedObject> {
    var frc: NSFetchedResultsController<T>?
    
    init(delegate: NSFetchedResultsControllerDelegate? = nil, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] = []) {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext:CoreDataService.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        frc?.delegate = delegate
        
        do {
            try frc?.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func getFetchedObjects() -> BehaviorRelay<[T]> {
        return BehaviorRelay<[T]>(value: frc?.fetchedObjects ?? [])
    }
}
