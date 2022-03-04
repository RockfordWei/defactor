//
//  Model.swift
//  defactor
//
//  Created by Rockford Wei on 2022-03-04.
//

import Foundation

class ListModel: Codable {
    var key: UInt = 0
    var items = [DetailModel]()
}
