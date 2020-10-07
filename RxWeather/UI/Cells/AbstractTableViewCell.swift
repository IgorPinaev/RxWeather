//
//  AbstractTableViewCell.swift
//  RxWeather
//
//  Created by Игорь on 07.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import UIKit

class AbstractTableViewCell: UITableViewCell {
    static var reuseId: String { String(describing: self) }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayouts() {}
    
    func setupElement(element: UIView, constraints: [NSLayoutConstraint]) {
        addSubview(element)
        element.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
}
