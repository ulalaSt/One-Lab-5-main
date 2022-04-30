//
//  TableDirector.swift
//  One-Lab-5
//
//  Created by user on 24.04.2022.
//

import UIKit
import SnapKit

//MARK: - to configure collectionview, and observe notification for event
class CollectionDirector: NSObject {
    
    private let collectionView: UICollectionView
    
    let actionProxy = CollectionActionProxy()
    
    private var items = [CellConfigurator]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    func updateItems(with newItems: [CellConfigurator]){
        self.items = newItems
    }

    private let collectionViewLayout: LeftAlignedCollectionViewFlowLayout = {
        let collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 20
        collectionViewLayout.minimumLineSpacing = 20
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return collectionViewLayout
    }()
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.collectionViewLayout = collectionViewLayout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(onActionEvent(notification:)), name: CollectionAction.notificationName, object: nil)
    }
    
    @objc private func onActionEvent(notification: Notification) {
        if let eventData = notification.userInfo?["data"] as? CollectionActionEventData,
           let cell = eventData.cell as? UICollectionViewCell,
           let indexPath = self.collectionView.indexPath(for: cell)
        {
            actionProxy.invoke(action: eventData.action,
                               cell: cell,
                               configurator: self.items[indexPath.row])
        }
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


