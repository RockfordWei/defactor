//
//  MainViewController.swift
//  defactor
//
//  Created by Rockford Wei on 2022-03-04.
//

import UIKit

class MainViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Welcome"
    }


    @IBAction func onClick(_ sender: Any) {
        let tableViewController = ListViewRouter.make()
        self.navigationController?.pushViewController(tableViewController, animated: true)
    }
}

