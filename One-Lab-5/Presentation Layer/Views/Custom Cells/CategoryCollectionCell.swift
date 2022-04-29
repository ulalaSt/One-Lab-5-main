//
//  CategoryCollectionCell.swift
//  One-Lab-5
//
//  Created by user on 27.04.2022.
//

import UIKit

typealias CategoriesCellConfigurator = CollectionCellConfigurator<CategoryCollectionCell, String>

class CategoryCollectionCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.backgroundColor = .lightGray
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview().inset(3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CategoryCollectionCell: ConfigurableCell {
    func configure(data: String) {
        
        label.text = data
    }
    
    typealias DataType = String
}
