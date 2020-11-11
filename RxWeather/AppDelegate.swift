//
//  AppDelegate.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 06.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = CityListController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataService.instance.saveContext()
    }
}
