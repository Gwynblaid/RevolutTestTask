// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit

protocol DataSourceDelegate: class {
	func willBeginUpdates()
	func dataReloaded()
	func move(_ from: IndexPath, to: IndexPath)
	func reload(section: Int)
	func didEndUpdates()
}

protocol DataSourceProtocol {
    var currentCurrency: CurrencyRate { get set }
    
    var numberOfSections: Int { get }
    var delegate: DataSourceDelegate? { get set }
    
    func register(in tableView: UITableView)
    func rows(in section: Int) -> Int
    
    func loadData(completion: @escaping (Bool) -> ())
    
    func sectionInfo(for section: Int) -> SectionInfo?
    func cellModel(for indexPath: IndexPath) -> CellModel?
	func selectCell(at indexPath: IndexPath)
}
