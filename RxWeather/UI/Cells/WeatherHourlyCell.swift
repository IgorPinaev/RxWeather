//
//  WeatherHourlyCell.swift
//  RxWeather
//
//  Created by Игорь on 07.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit

class WeatherHourlyCell: AbstractTableViewCell {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.register(WeatherHourlyCollectionCell.self, forCellWithReuseIdentifier: WeatherHourlyCollectionCell.reuseId)
        
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    private var hourlyData = [WeatherHourlyData]()
    
    func fill(hourlyData: [WeatherHourlyData]) {
        self.hourlyData = hourlyData
    }
    
    override func setupLayouts() {
        addSubview(collectionView)
        collectionView.fillParent()
    }
}
extension WeatherHourlyCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherHourlyCollectionCell.reuseId, for: indexPath) as! WeatherHourlyCollectionCell
        cell.fill(hourlyData: hourlyData[indexPath.item], now: indexPath.item == 0)
        
        return cell
    }
}
extension WeatherHourlyCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: collectionView.frame.size.height)
    }
}
