// Автор: Sergey Kharchenko
// Описание: Ответ от сервера

import Foundation

enum OperationCompletion<ResponseType>{
	//Успешно, возвращает результат ответа с типом ResponseType
	case success(ResponseType)
	//Ошибка, возвращает ошибку
	case failure(Error)
}
