// Автор: Sergey Kharchenko
// Описание: Класс отправки запросов в сеть.

import Foundation
import Reachability//Внешняя зависимость проверки состояния сети клиента

//Реализацию протокола NetworkHelperProtocol
final class NetworkHelper : NetworkHelperProtocol {
	let noConnection = NSError(domain: "com.internal.connection", code: 101, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No connection", comment: "")])
	
	func load<A>(resource: Resource<A>, completion: @escaping (OperationCompletion<A>) -> ()) -> Cancellation? {
		if Reachability()?.connection == Reachability.Connection.none {
			completion(.failure(noConnection))
			return nil
		}
		let request = URLRequest(resource: resource)
		let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let error = error {
				completion(.failure(error))
			} else {
				do {
					let data = data ?? Data()
					try completion(.success(resource.parse(data)))
				} catch let error {
					completion(.failure(error))
				}
			}
		}
		task.resume()
		return task
	}
}
