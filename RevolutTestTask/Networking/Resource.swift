// Автор: Sergey Kharchenko
// Описание: Ресурс содержащий все необходимые параметры для создания и обрабоки запроса

import Foundation

struct Resource<ResourceType> {
	let url: URL//url запроса
	let method: HttpMethod<Data>//метод запроса
	let parse: (Data) throws -> ResourceType//Парсер ответа от сервара
	let headers: [String : String]?//Заголовки запроса
	
	init(url: URL, method: HttpMethod<Data>, parse: @escaping (Data) throws -> ResourceType, headers: [String : String]? = nil) {
		self.url = url
		self.method = method
		self.parse = parse
		self.headers = headers
	}
}
