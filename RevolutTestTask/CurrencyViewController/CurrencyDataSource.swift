// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit

class DataSource: DataSourceProtocol {
    private var sections: [Section] = []
    private var networkHelper: NetworkHelperProtocol
    
    var delegate: DataSourceDelegate?
    
    init(networkHelper: NetworkHelperProtocol) {
        self.networkHelper = networkHelper
    }
}

// MARK: - DataSourceProtocol
extension DataSource {
    var numberOfSections: Int {
        return sections.count
    }
    
    func register(in tableView: UITableView) {
        CurrencyCellModel.register(in: tableView)
    }
    
    func rows(in section: Int) -> Int {
        return sections[section].models.count
    }
    
    func sectionInfo(for section: Int) -> SectionInfo? {
        return sections[section].info
    }
    
    func cellModel(for indexPath: IndexPath) -> CellModel {
        return sections[indexPath.section].models[indexPath.row]
    }
    
    func loadData(completion: @escaping (Bool) -> ()) {
        _ = networkHelper.load(resource: Resource<CurrencyResponse>.currencyGetResource(for: "RUB")) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                    self?.loadData(completion: completion)
                })
            case .success(let currency):
                let cellModels: [CellModel] = currency.rates.sorted(by: { (left, right) -> Bool in
                    left.currency.code < right.currency.code
                }).compactMap { CurrencyCellModel(currency: $0) }
                self.sections = [Section(info: nil, models: cellModels)]
                completion(true)
            }
        }
    }
}
