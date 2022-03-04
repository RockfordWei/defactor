//
//  DetailPresenter.swift
//  defactor
//
//  Created by Rockford Wei on 2022-03-04.
//

import Combine
import Foundation
import UIKit

protocol DetailPresenterDelegate {
    func onUpdate(detailModel: DetailModel)
}
class DetailPresenter {
    private var subscription: AnyCancellable? = nil
    var delegate: DetailPresenterDelegate? = nil
    init(interactor: DetailInteractor) {
        self.subscription = interactor.sink(receiveCompletion: { _ in
            print("detail presentation completed")
        }, receiveValue: { detailModel in
            self.delegate?.onUpdate(detailModel: detailModel)
        })
    }
}
