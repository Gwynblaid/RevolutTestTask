// Автор: Sergey Kharchenko
// Описание: Расширения для протокола Resource в котором добавлена связь с ObjectMapper-om

import Foundation
import ObjectMapper

extension Resource where ResourceType: ImmutableMappable {
	init(url: URL, method: HttpMethod<Data> = .get, headers: [String : String]?) {
		self.url = url
		self.method = method
		self.parse = { data in
			let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
			let res = try ResourceType(JSONObject: json)
			return res
		}
		self.headers = headers
	}
	
	init(url: URL, method: HttpMethod<Any> = .get, headers: [String : String]?) {
		let dataMethod = method.map { json in
			try! JSONSerialization.data(withJSONObject:json , options: JSONSerialization.WritingOptions())
		}
		self.init(url: url, method: dataMethod, headers: headers)
	}
}
