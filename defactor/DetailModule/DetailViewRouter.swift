//
//  DetailViewRouter.swift
//  defactor
//
//  Created by Rockford Wei on 2022-03-04.
//

import UIKit

class DetailViewRouter {
    static func make(model: DetailModel) -> UIViewController {
        let interactor = DetailInteractor()
        let presenter = DetailPresenter(interactor: interactor)
        let detailView = DetailViewController()
        presenter.delegate = detailView
        interactor.send(model)
        return detailView
    }
}
