// Автор: Sergey Kharchenko
// Описание: Протокол для объектов которые отменяют операции или какиее-то действия.

import Foundation

protocol Cancellation: class {
	//Функия отмены запроса
	func cancel()
}

//Реализация протокола для URLSessionTask(метод cancel() уже есть, реализовывать не надо)
extension URLSessionTask : Cancellation {
	
}

//Контэйнер для отмены запросов, необходим для отмены цепочки запросов, когда объект отмены меняется
final class RequestCancelContainer : Cancellation {
	//переменная содержащая объект отмены
	var requestCancel: Cancellation?
	
	func cancel() {
		requestCancel?.cancel()
	}
}
