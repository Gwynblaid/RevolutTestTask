// Автор: Sergey Kharchenko
// Описание: Расширение для URLRequest. Связь URLRequest c Resource.

import Foundation

extension URLRequest {
	//Создание запроса из Resource
	init<A>(resource: Resource<A>){
		self.init(url: resource.url)
		httpMethod = resource.method.stringValue
		if case let .post(data) = resource.method {
			httpBody = data
		}
		allHTTPHeaderFields = resource.headers
	}
}
