// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation

struct CurrencyRate {
    let currency: Currency
    let price: Double
}

extension CurrencyRate {
    enum Errors: Error {
        case dictionaryFailure
    }
}
