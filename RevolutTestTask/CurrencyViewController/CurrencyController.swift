// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation

class CurrencyController: Codable {
    var amount: Double = 1 {
        didSet {
            save()
        }
    }
    lazy private var order: [String] = Currency.allCurrencies.map { return $0.code }
    lazy private(set) var current: CurrencyRate = CurrencyRate(currency: Currency(code: "EUR"), price: 1)
    private var _rates: [CurrencyRate] = []
    var rates: [CurrencyRate] {
        set {
            _rates = newValue.sorted(by: { [unowned self] (left, right) -> Bool in
                guard let leftIndex = self.order.firstIndex(of: left.currency.code) else {
                    self.order.append(left.currency.code)
                    return false
                }
                guard let rightIndex = self.order.firstIndex(of: right.currency.code) else {
                    self.order.append(right.currency.code)
                    return true
                }
                return leftIndex < rightIndex
            })
        }
        get {
            return _rates
        }
    }
    
    init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decode(Double.self, forKey: .amount)
        let currentCode = try container.decode(String.self, forKey: .current)
        current = CurrencyRate(currency: Currency(code: currentCode), price: 1)
        order = try container.decode([String].self, forKey: .order)
        rates = []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(current.currency.code, forKey: .current)
        try container.encode(order, forKey: .order)
        try container.encode(amount, forKey: .amount)
    }
    
    func setNewCurrent(from index: Int) {
        if index >= _rates.count {
            return
        }
        var newCurrent = rates[index]
        amount = amount * newCurrent.price
        _rates.remove(at: index)
        _rates.insert(current, at: 0)
        order = _rates.map { $0.currency.code }
        _rates = _rates.map {
            CurrencyRate(currency: $0.currency, price: $0.price / newCurrent.price)
        }
        newCurrent.price = 1
        current = newCurrent
        save()
    }
}

private extension CurrencyController {
    enum CodingKeys: String, CodingKey {
        case current
        case amount
        case order
    }
}

extension CurrencyController {
    static private let saveKey = "CurrencyControllerKey"
    
    private func save() {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            return
        }
        UserDefaults.standard.set(jsonData, forKey: CurrencyController.saveKey)
    }
    
    static func load() -> CurrencyController? {
        guard let data = UserDefaults.standard.data(forKey: self.saveKey) else {
            return nil
        }
        return try? JSONDecoder().decode(self, from: data)
    }
}
