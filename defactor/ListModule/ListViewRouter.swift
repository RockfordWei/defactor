//
//  ListViewRouter.swift
//  defactor
//
//  Created by Rockford Wei on 2022-03-04.
//

import UIKit

class ListViewRouter {
    static func make() -> UIViewController {
        let interactor = ListInteractor()
        let presenter = ListPresenter(interactor: interactor, service: WebService.shared)
        let listView = ListViewController()
        listView.presenter = presenter
        presenter.delegate = listView
        return listView
    }
}
