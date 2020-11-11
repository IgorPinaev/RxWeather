//
//  FindCityView.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 16.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit

class FindCityView: UIView {
    let tableView = UITableView()
    let searchBar = UISearchBar()
    
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
private extension FindCityView {
    func addSubviews() {
        [tableView, searchBar].forEach(addSubview)
    }
    
    func makeConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureView() {
        backgroundColor = .white
        
        tableView.tableFooterView = UIView()
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.reuseId)
    }
}
