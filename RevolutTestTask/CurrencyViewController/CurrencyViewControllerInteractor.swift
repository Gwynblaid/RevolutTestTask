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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		dataSource.selectCell(at: indexPath)
		DispatchQueue.main.async {
			if let cellAction = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CellActionProtocol {
				tableView.setContentOffset(.zero, animated: false)
				cellAction.cellSelectedAction()
			}
		}
	}
}

// MARK: - Public
extension CurrencyViewControllerInteractor {
    func reloadData() {
		dataSource.loadData { _ in }
    }
}

// MARK: - DataSourceDelegate
extension CurrencyViewControllerInteractor: DataSourceDelegate {
	func reload(section: Int) {
		tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .none)
	}
	
	func willBeginUpdates() {
		tableView.beginUpdates()
	}
	
	func move(_ from: IndexPath, to: IndexPath) {
		tableView.moveRow(at: from, to: to)
	}
	
    func dataReloaded() {
		tableView.reloadData()
    }
	
	func didEndUpdates() {
		tableView.endUpdates()
	}
}

