// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit

class CurrencyViewControllerPresenter: NSObject {
    var dataSource: CurrencyInteractor
    var tableView: UITableView
    
    init(dataSource: CurrencyInteractor, tableView: UITableView) {
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
extension CurrencyViewControllerPresenter: UITableViewDataSource {
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
extension CurrencyViewControllerPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource.cellModel(for: indexPath)?.rowHeight ?? 0
    }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		dataSource.selectCell(at: indexPath)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
		DispatchQueue.main.async {
			if let cellAction = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CellActionProtocol {
				cellAction.cellSelectedAction()
			}
		}
	}
}

// MARK: - Public
extension CurrencyViewControllerPresenter {
    func reloadData() {
		dataSource.loadData { _ in }
    }
}

// MARK: - DataSourceDelegate
extension CurrencyViewControllerPresenter: CurrencyInteractorDelegate {
	func reload(section: Int) {
        if  section < tableView.numberOfSections  {
            let indexPathToUpdate: [IndexPath] = tableView.indexPathsForVisibleRows?.compactMap {
                if $0.section == section {
                    return $0
                }
                return nil
                } ?? []
            tableView.reloadRows(at: indexPathToUpdate, with: .none)
        } else {
            tableView.reloadData()
        }
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

