//
//  TableDirector.swift
//  One-Lab-5
//
//  Created by user on 24.04.2022.
//

import UIKit
import SnapKit

class CollectionDirector: NSObject {
    
    private let collectionView: UICollectionView
    
    private var items = [CellConfigurator]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let actionProxy = CollectionActionProxy()
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(onActionEvent(notification:)), name: CollectionAction.notificationName, object: nil)
    }
    
    @objc private func onActionEvent(notification: Notification) {
        if let eventData = notification.userInfo?["data"] as? CollectionActionEventData, let cell = eventData.cell as? UICollectionViewCell, let indexPath = self.collectionView.indexPath(for: cell) {
            actionProxy.invoke(action: eventData.action, cell: cell, configurator: self.items[indexPath.row])
        }
    }
    
    func updateItems(with newItems: [CellConfigurator]){
        self.items = newItems
    }
}

extension CollectionDirector: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let configurator = items[indexPath.row]
        collectionView.register(type(of: configurator).cellClass, forCellWithReuseIdentifier: type(of: configurator).identifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: configurator).identifier, for: indexPath)
        cell.layoutIfNeeded()
        configurator.configure(cell: cell)
        return cell
    }
}

extension CollectionDirector: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        CollectionAction.didSelect.invoke(cell: collectionView.cellForItem(at: indexPath)!)
    }
}


class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
}
