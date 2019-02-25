// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit
import FlagKit

struct Currency {
    let icon: UIImage
    let title: String
    let code: String
}

extension Currency {
    init?(stringArray: [String]) {
        if stringArray.count != 4 {
            return nil
        }
        if !Currency.availiableCurrenciesCodes.contains(stringArray[3]) {
            return nil
        }
        title = stringArray[2]
        code = stringArray[3]
        icon = Flag(countryCode: stringArray[1])?.image(style: .circle) ?? UIImage()
    }
    
    private static var availiableCurrenciesCodes: [String] = ["RUB", "AUD", "BGN",
                                                              "BRL", "CAD", "CHF",
                                                              "CNY", "CZK", "DKK",
                                                              "GBP", "HKD", "HRK",
                                                              "HUF", "IDR", "ILS",
                                                              "INR", "ISK", "JPY",
                                                              "KRW", "MXN", "MYR",
                                                              "NOK", "NZD", "PHP",
                                                              "PLN", "RON", "SEK",
                                                              "SGD", "THB", "TRY",
                                                              "USD", "ZAR", "EUR"]
    
    static var allCurrencies: [Currency] = {
        guard let filePath = Bundle.main.path(forResource: "country-code-to-currency-code-mapping", ofType: "csv") else {
            return []
        }
        guard let csvString = try? String(contentsOfFile: filePath) else {
            return []
        }
        let stringArray = csvString.split(separator: "\n")
		let result: [Currency] = stringArray.compactMap({
			$0.split(separator: ",")
		}).compactMap{ substrings in
			let strings = substrings.compactMap { String($0) }
			return Currency(stringArray: strings)
		}
		return result.sorted {
			$0.code < $1.code
		}
    }()
    
    init(code: String) {
        if let currency = Currency.allCurrencies.first(where: { $0.code == code }) {
            self = currency
        } else {
            self.init(icon: UIImage(), title: code, code: code)
        }
    }
}

extension Currency: Equatable {
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.code == rhs.code
    }
}
