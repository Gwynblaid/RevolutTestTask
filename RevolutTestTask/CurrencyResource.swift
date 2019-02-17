// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation

extension Resource where ResourceType == Currency {
	static func currencyGetResource(for currency: String) -> Resource<ResourceType> {
		let url = URL(string: "https://revolut.duckdns.org/latest?base=\(currency)")!
		return self.init(url: url, method: HttpMethod.get, headers: nil)
	}
}
