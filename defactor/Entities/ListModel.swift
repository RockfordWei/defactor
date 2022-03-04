//
//  Model.swift
//  defactor
//
//  Created by Rockford Wei on 2022-03-04.
//

import Foundation

class ListModel: Codable, Equatable {
    var key: UInt = 0
    var items = [DetailModel]()
    
    static func == (lhs: ListModel, rhs: ListModel) -> Bool {
        guard lhs.key == rhs.key,
              lhs.items.count == rhs.items.count
        else { return false }
        for i in 0..<lhs.items.count {
            let x = lhs.items[i]
            let y = rhs.items[i]
            if x != y {
                return false
            }
        }
        return true
    }
}
