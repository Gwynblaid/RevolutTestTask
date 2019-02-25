// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit

struct SavedData: Codable {
	let code: String
	let value: Double
}

class CurrencyViewControllerInteractor: CurrencyInteractor {
    
	private var semaphore = DispatchSemaphore(value: 1)
    private var networkHelper: NetworkHelperProtocol
    private var refreshTimeInterval: TimeInterval
    private var timer: Timer?
    private weak var requestCancellation: Cancellation?
    
    private var currencyController: CurrencyController {
        willSet {
            semaphore.wait()
        }
        didSet {
            semaphore.signal()
        }
    }
    private var rates: [CurrencyRate] {
        set {
            currencyController.rates = newValue
            DispatchQueue.main.async {
                self.delegate?.reload(section: 1)
            }
        }
        get {
            return currencyController.rates
        }
    }
    
    weak var delegate: CurrencyInteractorDelegate?
    
    init(networkHelper: NetworkHelperProtocol, refreshTimeInterval: TimeInterval) {
        self.networkHelper = networkHelper
		currencyController = CurrencyController.load() ?? CurrencyController()
		self.refreshTimeInterval = refreshTimeInterval
    }
}

// MARK: - DataSourceProtocol
extension CurrencyViewControllerInteractor {
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
				return CurrencyCellModel(currency: currencyController.current, multiplier: currencyController.amount, delegate: self)
			}
		case 1:
			if indexPath.row < rates.count {
				return CurrencyCellModel(currency: rates[indexPath.row], multiplier: currencyController.amount, delegate: self)
			}
		default:
			return nil
		}
		return nil
    }
    
    private func requestCurrencies(_ completion: @escaping (Bool) -> ()) {
        requestCancellation?.cancel()
        requestCancellation = networkHelper.load(resource: Resource<CurrencyResponse>.currencyGetResource(for: currencyController.current.currency.code)) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
				completion(false)
            case .success(let currency):
				self.rates = currency.rates
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
			currencyController.setNewCurrent(from: indexPath.row)
			delegate?.dataReloaded()
		}
	}
}

extension CurrencyViewControllerInteractor: CurrencyCellModelDelegate {
	func cellModel(_ cellModel: CurrencyCellModel, didChanged value: Double) {
		currencyController.amount = value
		delegate?.reload(section: 1)
	}
}
