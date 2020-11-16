//
//  CityListView.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 11.11.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit

class CityListView: UIView {
    let tableView = UITableView()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        addSubviews()
        makeConstraints()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension CityListView {
    func addSubviews() {
        [tableView].forEach(addSubview)
    }
    
    func makeConstraints() {
        tableView.fillParent()
    }
    
    func configureView() {
        backgroundColor = .white
        
        tableView.tableFooterView = UIView()
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.reuseId)
    }
}
