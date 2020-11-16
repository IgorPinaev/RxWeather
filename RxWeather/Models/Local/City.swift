//
//  City.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 10.11.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import Foundation
import CoreData

class City: NSManagedObject {
    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var lat: Double
    @NSManaged var lon: Double
    @NSManaged var country: String
    
    class func from(struct weatherCity: WeatherCity) {
        let city = City(context: CoreDataService.instance.context)
        
        city.id = NSNumber(value: weatherCity.id)
        city.name = weatherCity.name
        city.lat = weatherCity.lat
        city.lon = weatherCity.lon
        city.country = weatherCity.country
        
        CoreDataService.instance.saveContext()
    }
}
