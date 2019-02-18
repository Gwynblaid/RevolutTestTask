// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit

class CurrencyViewControllerInteractor: NSObject {
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
extension CurrencyViewControllerInteractor: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.rows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return dataSource.cellModel(for: indexPath)?.cell(for: tableView) ?? UITableViewCell(style: .default, reuseIdentifier: nil)
    }
}

// MARK: - UITableViewDelegate
extension CurrencyViewControllerInteractor: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource.cellModel(for: indexPath)?.rowHeight ?? 0
    }
}

// MARK: - Public
extension CurrencyViewControllerInteractor {
    func reloadData() {
		dataSource.loadData { _ in }
    }
    
    var currentCurrency: Currency {
        set {
            dataSource.currentCurrency = newValue
        }
        get {
            return dataSource.currentCurrency
        }
    }
    
    var availiableCurrecies: [Currency] {
        return Currency.allCurrencies
    }
}

// MARK: - DataSourceDelegate
extension CurrencyViewControllerInteractor: DataSourceDelegate {
    func dataReloaded() {
		DispatchQueue.main.async { [weak self] in
			self?.tableView.reloadData()
		}
    }
}

