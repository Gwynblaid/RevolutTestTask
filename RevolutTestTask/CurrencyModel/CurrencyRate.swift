// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation

struct CurrencyRate {
    let currency: Currency
    var price: Double
}

extension CurrencyRate {
    enum Errors: Error {
        case dictionaryFailure
    }
}

extension CurrencyRate: Hashable {
    static func == (lhs: CurrencyRate, rhs: CurrencyRate) -> Bool {
        return lhs.currency == rhs.currency
    }
    
    public var hashValue: Int {
        return currency.code.hashValue
    }
}
