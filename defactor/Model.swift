//
//  DataModel.swift
//  defactor
//
//  Created by Rockford Wei on 2022-03-04.
//

import Foundation

struct DataItemModel: Codable {
    let id: UInt
    let text: String	
    init(id i: UInt, text t: String) {
        id = i; text = t
    }
    private static let formatter: NumberFormatter = {
        let fmt = NumberFormatter()
        fmt.numberStyle = .spellOut
        return fmt
    }()
    static func build(x: UInt) -> DataItemModel {
        let y = NSNumber(integerLiteral: Int(x))
        let z = formatter.string(from: y) ?? "-/-"
        return DataItemModel(id: x, text: z)
    }
}


class DataListModel: Codable {
    var items = [DataItemModel]()
}
