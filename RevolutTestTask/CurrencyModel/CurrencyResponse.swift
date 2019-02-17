// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import ObjectMapper

struct CurrencyResponse {
    let currency: Currency
	let date: Date
	
	let rates: [CurrencyRate]
}

extension CurrencyResponse: ImmutableMappable {
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
        let code: String = try map.value("base")
		currency = Currency(code: code)
		let dateString: String = try map.value("date")
		guard let date = CurrencyResponse.dateFormatter.date(from: dateString) else {
			throw Errors.failureDateFormat(dateString)
		}
		self.date = date
		let ratesDictionaries: [String: Double] = try map.value("rates")
		rates = ratesDictionaries.compactMap {
            CurrencyRate(currency: Currency(code: $0), price: $1)
		}
	}
}
