//
//  TableCellConfigurator.swift
//  One-Lab-5
//
//  Created by user on 24.04.2022.
//

import UIKit

class TableCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UITableViewCell {
        
    static var identifier: String { return String(describing: CellType.self) }
    
    static var cellClass: AnyClass { return CellType.self }
        
    var data: DataType
    
    init(data: DataType){
        self.data = data
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(data: data)
    }
}

