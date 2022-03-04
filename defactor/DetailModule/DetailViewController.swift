//
//  DetailViewController.swift
//  defactor
//
//  Created by Rockford Wei on 2022-03-04.
//

import UIKit

class DetailViewController: UIViewController {
    private let textView: UITextView = {
        let t = UITextView()
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        textView.font = UIFont.systemFont(ofSize: 24)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
}

extension DetailViewController: DetailPresenterDelegate {
    func onUpdate(detailModel: DetailModel) {
        self.navigationItem.title = "\(detailModel.id)"
        self.textView.text = detailModel.text
    }
}
