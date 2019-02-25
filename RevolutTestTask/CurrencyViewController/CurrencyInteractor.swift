// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit

protocol CurrencyInteractorDelegate: class {
	func willBeginUpdates()
	func dataReloaded()
	func move(_ from: IndexPath, to: IndexPath)
	func reload(section: Int)
	func didEndUpdates()
}

protocol CurrencyInteractor {
    var numberOfSections: Int { get }
    var delegate: CurrencyInteractorDelegate? { get set }
    
    func register(in tableView: UITableView)
    func rows(in section: Int) -> Int
    
    func loadData(completion: @escaping (Bool) -> ())
    
    func sectionInfo(for section: Int) -> SectionInfo?
    func cellModel(for indexPath: IndexPath) -> CellModel?
	func selectCell(at indexPath: IndexPath)
}
