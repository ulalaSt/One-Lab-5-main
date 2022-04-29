//
//  ConfigurableCell.swift
//  One-Lab-5
//
//  Created by user on 24.04.2022.
//

import Foundation

protocol ConfigurableCell {
    associatedtype DataType
    func configure(data: DataType) -> Void
}

extension ConfigurableCell {
    static var identifier: String {return String(describing: Self.self)}
}
