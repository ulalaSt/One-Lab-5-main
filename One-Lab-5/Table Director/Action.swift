//
//  Action.swift
//  One-Lab-5
//
//  Created by user on 24.04.2022.
//

import UIKit

enum Action: Hashable {
    case didSelect
    
    var hashValue: Int {
        switch self {
        case .didSelect: return 0
        }
    }
}

struct ActionEventData {
    let action: Action
    let cell: UIView
}

extension Action {
    static let notificationName = NSNotification.Name("cellAction")
    
    func invoke(cell: UIView) {
        NotificationCenter.default.post(name: Action.notificationName, object: nil, userInfo: ["data": ActionEventData(action: self, cell: cell)])
    }
}
