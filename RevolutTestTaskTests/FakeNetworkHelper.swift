// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
@testable import RevolutTestTask

class FakeNetworkHelper: NetworkHelperProtocol {
	enum Errors: Error {
		case notSupprotedType
	}
	
	
	
	private let rubResponse: [String: Any] = [
												"base": "RUB",
												"date": "2018-09-06",
												"rates": ["AUD": 0.020326,"BGN": 0.024593,"BRL": 0.060257,"CAD": 0.019288]
												]
	private let errorResponse = ["error":"Code invalid"]
	private let textResonse = "404 error"
	
	var ratesCount: Int {
		return (rubResponse["rates"] as! [String: Double]).count
	}
	
	func load<A>(resource: Resource<A>, completion: @escaping (OperationCompletion<A>) -> ()) -> Cancellation? {
		if A.self is CurrencyResponse.Type {
			do {
				if resource.url.absoluteString.contains("EUR") {
					let result = try resource.parse(try! JSONSerialization.data(withJSONObject: rubResponse, options: .prettyPrinted))
					completion(OperationCompletion.success(result))
				} else if resource.url.absoluteString.contains("US") {
					_ = try resource.parse(try! JSONSerialization.data(withJSONObject: errorResponse, options: .prettyPrinted))
				} else {
					_ = try resource.parse(textResonse.data(using: .utf8)!)
				}
			} catch let error {
				completion(OperationCompletion.failure(error))
			}
			return nil
		}
		completion(OperationCompletion.failure(Errors.notSupprotedType))
		return nil
	}
}
