// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit

protocol DataSourceDelegate {
    func dataReloaded()
    func dataChanged(in section: Int)
    func dataChanged(at indexPath: IndexPath)
}

protocol DataSourceProtocol {
    var numberOfSections: Int { get }
    var delegate: DataSourceDelegate? { get set }
    
    func register(in tableView: UITableView)
    func rows(in section: Int) -> Int
    
    func loadData(completion: @escaping (Bool) -> ())
    
    func sectionInfo(for section: Int) -> SectionInfo?
    func cellModel(for indexPath: IndexPath) -> CellModel
}
