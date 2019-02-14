// Автор: Sergey Kharchenko
// Описание: enum Описывающий тип запроса

import Foundation

//Тип запроса
enum HttpMethod<Body> {
	case get//GET
	case post(Body)//POST, где Body - параметры запроса
}

extension HttpMethod {
	//Строчное занчение типов
	var stringValue: String{
		switch self {
		case .get:
			return "GET"
		case .post:
			return "POST"
		}
	}
	
	//Маппер одного типа тела в другой
	func map<B>(f: (Body) -> B) -> HttpMethod<B> {
		switch self {
		case .get:
			return .get
		case .post(let body):
			return .post(f(body))
		}
	}
}
