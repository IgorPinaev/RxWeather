//
//  WeatherHourlyCell.swift
//  RxWeather
//
//  Created by Игорь on 07.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit
import RxSwift

class WeatherHourlyCell: AbstractTableViewCell {
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var disposeBag = DisposeBag()
    
    func fill(hourlyData: [WeatherHourlyData]) {
        Observable.just(hourlyData)
            .bind(to: collectionView.rx.items(cellIdentifier: WeatherHourlyCollectionCell.reuseId, cellType: WeatherHourlyCollectionCell.self)) { row, element, cell in
                cell.fill(hourlyData: element, now: row == 0)
        }
        .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    override func setupLayouts() {
        addCollectionView()
        configureCollectionView()
    }
    
    private func addCollectionView() {
        addSubview(collectionView)
        collectionView.fillParent()
    }
    
    private func configureCollectionView() {
        collectionView.register(WeatherHourlyCollectionCell.self, forCellWithReuseIdentifier: WeatherHourlyCollectionCell.reuseId)
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
extension WeatherHourlyCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: collectionView.frame.size.height)
    }
}
