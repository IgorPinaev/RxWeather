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

class FetchedResultsService<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    private let frc: NSFetchedResultsController<T>
    private var relay: BehaviorRelay<[T]>!
    
    private init(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] = []) {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext:CoreDataService.instance.context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    static func fetchObjects(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] = []) -> BehaviorRelay<[T]> {
        let service = FetchedResultsService<T>(predicate: predicate, sortDescriptors: sortDescriptors)
        
        service.relay = BehaviorRelay<[T]>(value: service.frc.fetchedObjects ?? [])
        
        return service.relay
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Hello")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let object = anObject as? T else { return }
        
        var values = relay.value
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                values.insert(object, at: indexPath.row)
                relay.accept(values)
            }
        case .delete:
            if let indexPath = indexPath {
                values.remove(at: indexPath.row)
                relay.accept(values)
            }
        case .move:
            break
        case .update:
            if let indexPath = indexPath {
                values[indexPath.row] = object
                relay.accept(values)
            }
        default:
            break
        }
    }
}
