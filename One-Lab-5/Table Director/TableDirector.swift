//
//  TableDirector.swift
//  One-Lab-5
//
//  Created by user on 24.04.2022.
//

import Foundation
import UIKit
import SnapKit

class TableDirector: NSObject {
    
    private let tableView: UITableView
    
    private var tableTitle: String?
    
    private var heightForRow: Double?
    
    private var items = [CellConfigurator]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let headerSearchField: UITextField = {
        let headerSearchField = UITextField()
        headerSearchField.placeholder = "Search for News..."
        return headerSearchField
    }()
    private let headerTitleLabel: UILabel = {
        let headerTitleLabel = UILabel()
        headerTitleLabel.font = UIFont(name: "NewYorkMedium-Bold", size: 30)
        headerTitleLabel.text = "Top News"
        return headerTitleLabel
    }()
    
    let actionProxy = ActionProxy()
        
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(onActionEvent(notification:)), name: Action.notificationName, object: nil)
    }
    
    @objc private func onActionEvent(notification: Notification) {
        if let eventData = notification.userInfo?["data"] as? ActionEventData, let cell = eventData.cell as? UITableViewCell, let indexPath = self.tableView.indexPath(for: cell) {
            actionProxy.invoke(action: eventData.action, cell: cell, configurator: self.items[indexPath.row])
        }
    }

    func updateItems(with newItems: [CellConfigurator]){
        self.items = newItems
    }
    
    func setTitle(with newTitle: String){
        self.tableTitle = newTitle
    }
}

extension TableDirector: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let configurator = items[indexPath.row]
        tableView.register(type(of: configurator).cellClass, forCellReuseIdentifier: type(of: configurator).identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: configurator).identifier, for: indexPath)
        configurator.configure(cell: cell)
        return cell
    }
}

extension TableDirector: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Action.didSelect.invoke(cell: tableView.cellForRow(at: indexPath)!)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableTitle ?? ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont(name: "NewYorkMedium-Bold", size: 30)
        header.textLabel?.frame = header.bounds
    }
}
