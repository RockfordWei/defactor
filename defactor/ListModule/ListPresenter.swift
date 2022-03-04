//
//  ListPresenter.swift
//  defactor
//
//  Created by Rockford Wei on 2022-03-04.
//

import Combine
import Foundation

protocol ListPresenterDelegate {
    func onUpdate(listModel: ListModel)
}

class ListPresenter {
    var delegate: ListPresenterDelegate? = nil
    private var subscription: AnyCancellable? = nil
    private var service: WebService? = nil
    private var interactor: ListInteractor
    init(interactor: ListInteractor, service: WebService) {
        self.interactor = interactor
        self.service = service
        self.subscription = interactor.sink(receiveCompletion: { _ in
            print("list presentation completed")
        }, receiveValue: { listModel in
            self.delegate?.onUpdate(listModel: listModel)
        })
    }
    func onQuery(value: UInt) {
        if value > 0 {
            service?.query(value: value) { listModel in
                self.interactor.send(listModel)
            }
        } else {
            DispatchQueue.main.async {
                self.interactor.send(ListModel())
            }
        }
    }
}
