// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit

class CurrenciesDataSource: DataSourceProtocol {
    private struct UserDefaultsParams {
        static let defaultCurrencyCode = "EUR"
        static let currentCurrencyKey = "CurrentCurrencyKey"
    }
    
	private var sections: [Section] = [] {
		didSet {
			delegate?.dataReloaded()
		}
	}
    private var networkHelper: NetworkHelperProtocol
    private var refreshTimeInterval: TimeInterval
    private var timer: Timer?
    private weak var requestCancellation: Cancellation?
    
    var currentCurrency: Currency {
        didSet {
            UserDefaults.standard.set(currentCurrency.code, forKey: UserDefaultsParams.currentCurrencyKey)
        }
    }
    weak var delegate: DataSourceDelegate?
    
    init(networkHelper: NetworkHelperProtocol, refreshTimeInterval: TimeInterval = 60) {
        self.networkHelper = networkHelper
        let code = UserDefaults.standard.string(forKey: UserDefaultsParams.currentCurrencyKey) ?? UserDefaultsParams.defaultCurrencyCode
        currentCurrency = Currency(code: code)
        self.refreshTimeInterval = refreshTimeInterval
    }
}

// MARK: - DataSourceProtocol
extension CurrenciesDataSource {
    var numberOfSections: Int {
        return sections.count
    }
    
    func register(in tableView: UITableView) {
        CurrencyCellModel.register(in: tableView)
    }
    
    func rows(in section: Int) -> Int {
		if section < sections.count {
			return sections[section].models.count
		}
		return 0
    }
    
    func sectionInfo(for section: Int) -> SectionInfo? {
		if section < sections.count {
			return sections[section].info
		}
		return nil
    }
    
    func cellModel(for indexPath: IndexPath) -> CellModel? {
		if indexPath.section < sections.count && indexPath.row < sections[indexPath.section].models.count {
			return sections[indexPath.section].models[indexPath.row]
		}
		return nil
    }
    
    private func requestCurrencies(_ completion: @escaping (Bool) -> ()) {
        requestCancellation?.cancel()
        requestCancellation = networkHelper.load(resource: Resource<CurrencyResponse>.currencyGetResource(for: currentCurrency.code)) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
				completion(false)
            case .success(let currency):
                let cellModels: [CellModel] = currency.rates.sorted(by: { (left, right) -> Bool in
                    left.currency.code < right.currency.code
                }).compactMap { CurrencyCellModel(currency: $0) }
                self.sections = [Section(info: nil, models: cellModels)]
                completion(true)
            }
        }
    }
    
    func loadData(completion: @escaping (Bool) -> ()) {
        requestCurrencies(completion)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: refreshTimeInterval, repeats: true, block: { [weak self] timer in
            print(Date())
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.requestCurrencies{ _ in }
        })
    }
}
