// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import XCTest

@testable import RevolutTestTask

class ApiTests: XCTestCase {
	
	func testCurrencyRequest() {
		let helper = NetworkHelper()
		let requestReource = Resource(url: URL(string: "https://revolut.duckdns.org/latest?base=EUR")!, method: .get, parse: { data -> String?  in
			let string = String(data: data, encoding: .utf8)
			return string
		}, headers: nil)
		let semaphore = DispatchSemaphore(value: 0)
		_ = helper.load(resource: requestReource) { result in
			switch result {
			case .failure(let error):
				print(error)
			case .success(let string):
				print(string ?? "")
			}
			semaphore.signal()
		}
		semaphore.wait()
	}
}
