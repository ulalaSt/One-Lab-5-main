//
//  CellConfigurator.swift
//  One-Lab-5
//
//  Created by user on 24.04.2022.
//

import Foundation
import UIKit

protocol CellConfigurator {
    static var identifier: String { get }
    
    static var cellClass: AnyClass { get }
        
    func configure(cell: UIView) -> Void
}
