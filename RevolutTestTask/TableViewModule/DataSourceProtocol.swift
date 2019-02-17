// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit

protocol DataSourceDelegate: class {
    func dataReloaded()
}

protocol DataSourceProtocol {
    var currentCurrency: Currency { get set }
    
    var numberOfSections: Int { get }
    var delegate: DataSourceDelegate? { get set }
    
    func register(in tableView: UITableView)
    func rows(in section: Int) -> Int
    
    func loadData(completion: @escaping (Bool) -> ())
    
    func sectionInfo(for section: Int) -> SectionInfo?
    func cellModel(for indexPath: IndexPath) -> CellModel
}
