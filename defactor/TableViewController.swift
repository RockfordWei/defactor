//
//  TableViewController.swift
//  defactor
//
//  Created by Rockford Wei on 2022-03-04.
//

import UIKit
import Combine

class TableViewController: UIViewController {
    
    private let searchEvent = PassthroughSubject<UInt, Error>()
    private var searchControl: AnyCancellable? = nil
    private let cellId = UUID().uuidString
    private var records = [Record]()
    private func setupLayout() {
        let searchBar: UISearchBar = {
            let bar = UISearchBar()
            bar.translatesAutoresizingMaskIntoConstraints = false
            bar.searchTextField.keyboardType = .numberPad
            return bar
        }()
        let tableView: UITableView = {
            let table = UITableView()
            table.translatesAutoresizingMaskIntoConstraints = false
            return table
        }()
        
        self.searchControl = searchEvent.sink(receiveCompletion: { _ in
            print("search event marked completion")
        }, receiveValue: { integer in
            WebService.shared.query(value: integer) { records in
                self.records = records
                tableView.reloadData()
            }
        })
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        tableView.register(TableCell.self, forCellReuseIdentifier: cellId)
        NSLayoutConstraint.activate([
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 48),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.centerXAnchor.constraint(equalTo: searchBar.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: searchBar.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Demo"
        setupLayout()
    }
}

extension TableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let uint = UInt(searchText) {
            searchEvent.send(uint)
        }
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}
extension TableViewController: UITableViewDataSource {
    
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
