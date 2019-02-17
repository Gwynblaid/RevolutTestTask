// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit

class CurrencyTableViewDataSource: NSObject {
    var dataSource: DataSourceProtocol
    var tableView: UITableView
    
    init(dataSource: DataSourceProtocol, tableView: UITableView) {
        self.dataSource = dataSource
        self.tableView = tableView
        super.init()
        self.dataSource.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        self.dataSource.register(in: tableView)
    }
}

// MARK: - UITableViewDataSource
extension CurrencyTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.rows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource.cellModel(for: indexPath).cell(for: tableView)
    }
}

// MARK: - UITableViewDelegate
extension CurrencyTableViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource.cellModel(for: indexPath).rowHeight
    }
}

// MARK: - Public
extension CurrencyTableViewDataSource {
    func reloadData() {
        dataSource.loadData { result in
            if result {
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - DataSourceDelegate
extension CurrencyTableViewDataSource: DataSourceDelegate {
    func dataBeginUpdates() {
        tableView.beginUpdates()
    }
    
    func dataReloaded() {
        tableView.reloadData()
    }
    
    func dataChanged(in section: Int) {
        tableView.reloadSections(IndexSet(arrayLiteral: section), with: .automatic)
    }
    
    func dataChanged(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func dataEndUpdates() {
        tableView.endUpdates()
    }
}

