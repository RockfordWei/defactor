//
//  TableViewController.swift
//  defactor
//
//  Created by Rockford Wei on 2022-03-04.
//

import UIKit
import Combine

class ListViewController: UIViewController {
    
    var presenter: ListPresenter? = nil
    
    private let cellId = UUID().uuidString
    private var records = [DetailModel]()
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.searchTextField.keyboardType = .numberPad
        return bar
    }()
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private func setupLayout() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        view.addSubview(searchBar)
        view.addSubview(tableView)
        tableView.register(TableCell.self, forCellReuseIdentifier: cellId)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 48),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Demo"
        setupLayout()
    }
}

extension ListViewController: ListPresenterDelegate {
    func onUpdate(listModel: ListModel) {
        self.records = listModel.items
        self.tableView.reloadData()
    }
}
extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let uint = UInt(searchText) ?? 0
        self.presenter?.onQuery(value: uint)
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailViewController = DetailViewRouter.make(model: records[indexPath.row])
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableCell
        if let xell = tableView.dequeueReusableCell(withIdentifier: cellId) as? TableCell {
            cell = xell
        } else {
            cell = TableCell(style: .default, reuseIdentifier: cellId)
        }
        let record = records[indexPath.row]
        cell.textLabel?.text = "\(record.id)"
        cell.detailTextLabel?.text = record.text
        return cell
    }

}

fileprivate class TableCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
