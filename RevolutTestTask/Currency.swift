// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit
import ObjectMapper

struct CurrencyRate {
	let icon: UIImage
	let shortTitle: String
	let title: String
	let price: Double
}

struct Currency {
	let icon: UIImage
	let shortTitle: String
	let title: String
	let date: Date
	
	let rates: [CurrencyRate]
}

extension CurrencyRate {
	enum Errors: Error {
		case dictionaryFailure
	}
}

extension Currency {
	static var availiableCurrencies: [String] = ["RUB", "AUD", "BGN", "BRL", "CAD", "CHF", "CNY", "CZK", "DKK", "GBP", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "ISK", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PLN", "RON", "SEK", "SGD", "THB", "TRY", "USD", "ZAR", "EUR"]
}

extension Currency: ImmutableMappable {
	enum Errors: Error {
		case failureDateFormat(String)
	}
	
	static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		formatter.timeZone = TimeZone(abbreviation: "UTC")
		formatter.calendar = Calendar(identifier: .gregorian)
		return formatter
	}()
	
	init(map: Map) throws {
		if let error = try? CurrencyErrorResponse(map: map) {
			throw error
		}
		shortTitle = try map.value("base")
		title = shortTitle
		let dateString: String = try map.value("date")
		guard let date = Currency.dateFormatter.date(from: dateString) else {
			throw Errors.failureDateFormat(dateString)
		}
		self.date = date
		let ratesDictionaries: [String: Double] = try map.value("rates")
		rates = ratesDictionaries.compactMap {
			CurrencyRate(icon: UIImage(), shortTitle: $0, title: $0, price: $1)
		}
		icon = UIImage()
	}
}

struct CurrencyErrorResponse: Error {
	let description: String
}

extension CurrencyErrorResponse: ImmutableMappable {
	init(map: Map) throws {
		description = try map.value("error")
	}
}
