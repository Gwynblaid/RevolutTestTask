// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import XCTest

@testable import RevolutTestTask

class TestCurrencyParser: XCTestCase {

	let mockNetworkHelper = FakeNetworkHelper()
	
	func testSuccessResponse()  {
		_ = mockNetworkHelper.load(resource: Resource<CurrencyResponse>.currencyGetResource(for: "EUR")) { result in
			if case .failure = result {
				XCTFail("Parsing for good response now working")
			}
		}
	}
	
	func testServerError() {
		_ = mockNetworkHelper.load(resource: Resource<CurrencyResponse>.currencyGetResource(for: "US")) { result in
			switch result {
			case .success:
				XCTFail("Should be error from server, not success response")
			case .failure(let error):
				guard error is CurrencyErrorResponse else {
					XCTFail("Error should be CurrencyErrorResponse type")
					return
				}
				return
			}
		}
	}
	
	func testTextResponse() {
		_ = mockNetworkHelper.load(resource: Resource<CurrencyResponse>.currencyGetResource(for: "LAOS")) { result in
			if case .success = result {
				XCTFail("Should be error for not JSON response")
			}
		}
	}
}
