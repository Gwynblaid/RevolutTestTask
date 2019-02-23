// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit

struct SavedData: Codable {
	let code: String
	let value: Double
}

class CurrenciesDataSource: DataSourceProtocol {
    private struct UserDefaultsParams {
		static let defaultCurrencyCode = SavedData(code: "EUR", value: 1)
        static let currentCurrencyKey = "CurrentCurrencyKey"
		
		static let defaultCurreincies = Currency.allCurrencies.map { $0.code }
		static let currenciesKey = "CurrenciesKey"
    }
    
	private var rates: [CurrencyRate] {
		willSet {
			semaphore.wait()
		}
		
		didSet {
			DispatchQueue.main.async { [weak self] in
				if oldValue.count == 0 {
					self?.delegate?.dataReloaded()
				} else {
					self?.delegate?.reload(section: 1)
				}
			}
			semaphore.signal()
		}
	}
	private var semaphore = DispatchSemaphore(value: 1)
    private var networkHelper: NetworkHelperProtocol
    private var refreshTimeInterval: TimeInterval
    private var timer: Timer?
    private weak var requestCancellation: Cancellation?
    
    var currentCurrency: CurrencyRate {
		willSet {
			semaphore.wait()
		}
        didSet {
			defer { semaphore.signal() }
			guard let data = try? JSONEncoder().encode(SavedData(code: currentCurrency.currency.code, value: currentCurrency.price)) else {
				return
			}
			UserDefaults.standard.set(data, forKey: UserDefaultsParams.currentCurrencyKey)
			
        }
    }
	private var allCurrencies: [String] {
		didSet {
			UserDefaults.standard.set(allCurrencies, forKey: UserDefaultsParams.currenciesKey)
		}
	}
    weak var delegate: DataSourceDelegate?
    
    init(networkHelper: NetworkHelperProtocol, refreshTimeInterval: TimeInterval) {
        self.networkHelper = networkHelper
		var values = UserDefaultsParams.defaultCurrencyCode
		if let data = UserDefaults.standard.data(forKey: UserDefaultsParams.currentCurrencyKey) {
			if let savedValues = try? JSONDecoder().decode(SavedData.self, from: data) {
				values = savedValues
			}
		}
		currentCurrency = CurrencyRate(currency: Currency(code: values.code), price: values.value)
		self.refreshTimeInterval = refreshTimeInterval
		allCurrencies = (UserDefaults.standard.array(forKey: UserDefaultsParams.currenciesKey) as? [String]) ?? UserDefaultsParams.defaultCurreincies
		rates = []
    }
}

// MARK: - DataSourceProtocol
extension CurrenciesDataSource {
    var numberOfSections: Int {
		return rates.count > 0 ? 2 : 1
    }
    
    func register(in tableView: UITableView) {
        CurrencyCellModel.register(in: tableView)
    }
    
    func rows(in section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			return rates.count
		default:
			return 0
		}
    }
    
    func sectionInfo(for section: Int) -> SectionInfo? {
		return nil
    }
    
    func cellModel(for indexPath: IndexPath) -> CellModel? {
		switch indexPath.section {
		case 0:
			if indexPath.row == 0 {
				return CurrencyCellModel(currency: currentCurrency, multiplier: 1, delegate: self)
			}
		case 1:
			if indexPath.row < rates.count {
				return CurrencyCellModel(currency: rates[indexPath.row], multiplier: currentCurrency.price, delegate: self)
			}
		default:
			return nil
		}
		return nil
    }
    
    private func requestCurrencies(_ completion: @escaping (Bool) -> ()) {
        requestCancellation?.cancel()
        requestCancellation = networkHelper.load(resource: Resource<CurrencyResponse>.currencyGetResource(for: currentCurrency.currency.code)) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
				completion(false)
            case .success(let currency):
				let rates = currency.rates.sorted(by: {[unowned self]  (left, right) -> Bool in
					guard let leftIndex = self.allCurrencies.firstIndex(of: left.currency.code) else {
						self.allCurrencies.append(left.currency.code)
						return false
					}
					guard let rightIndex = self.allCurrencies.firstIndex(of: right.currency.code) else {
						self.allCurrencies.append(right.currency.code)
						return true
					}
					return leftIndex < rightIndex
				}).compactMap{
					return CurrencyRate(currency: $0.currency, price: $0.price)
				}
				self.rates = rates
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
	
	func selectCell(at indexPath: IndexPath) {
		if indexPath.section == 1 && indexPath.row < rates.count{
			let newCurrent = rates[indexPath.row]
			rates.remove(at: indexPath.row)
			rates.insert(self.currentCurrency, at: 0)
			self.currentCurrency = newCurrent
			allCurrencies = [currentCurrency.currency.code] + rates.map { $0.currency.code }
			delegate?.willBeginUpdates()
			delegate?.move(indexPath, to: IndexPath(row: 0, section: 0))
			delegate?.move(IndexPath(row: 0, section: 0), to: IndexPath(row: 0, section: 1))
			delegate?.didEndUpdates()
		}
	}
}

extension CurrenciesDataSource: CurrencyCellModelDelegate {
	func cellModel(_ cellModel: CurrencyCellModel, didChanged value: Double) {
		currentCurrency.price = value
		delegate?.reload(section: 1)
	}
}

extension Array {
	mutating func bringIndexToTop(_ index: Int) -> Bool {
		if index == 0 { return false}
		let value = self[index]
		remove(at: index)
		self.insert(value, at: 0)
		return true
	}
}
