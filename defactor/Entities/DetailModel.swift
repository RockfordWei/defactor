//
//  DetailModel.swift
//  defactor
//
//  Created by Rockford Wei on 2022-03-04.
//

import Foundation

struct DetailModel: Codable, Equatable {
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
    static func build(x: UInt) -> DetailModel {
        let y = NSNumber(integerLiteral: Int(x))
        let z = formatter.string(from: y) ?? "-/-"
        return DetailModel(id: x, text: z)
    }
    static func == (lhs: DetailModel, rhs: DetailModel) -> Bool {
        return lhs.id == rhs.id && lhs.text == rhs.text
    }
}
