// Автор: Sergey Kharchenko
// Описание: Протокол для работы с сервером на основе ресурсов.

import Foundation

protocol NetworkHelperProtocol {
	//Загрузка ресурса из сети(можно мокать и создавать фейковый сервер)
	func load<A>(resource: Resource<A>, completion: @escaping (OperationCompletion<A>) -> ()) -> Cancellation?
	//Загрузка ресурса из сети(можно мокать и создавать фейковый сервер), с указанием количества попыток
	//MARK: (*)
	func load<A>(resource: Resource<A>, repeatTime: Int, delayTime: TimeInterval, completion: @escaping (OperationCompletion<A>) -> ()) -> Cancellation?
}

extension NetworkHelperProtocol {
	//Реализация по умолчанию метода (*)
	func load<A>(resource: Resource<A>, repeatTime: Int, delayTime: TimeInterval, completion: @escaping (OperationCompletion<A>) -> ()) -> Cancellation? {
		let container = RequestCancelContainer()
		container.requestCancel = self.load(resource: resource) { (result) in
			switch result {
			case .failure(_):
				if repeatTime > 0 {
					DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: {
						self.load(resource: resource, repeatTime: repeatTime - 1, delayTime: delayTime, container: container, completion: completion)
					});
				}else{
					completion(result)
				}
			case .success(_):
				completion(result)
			}
		}
		return container
	}
	
	//Вспомогательный метод для реализации по умолчанию метода (*)
	private func load<A>(resource: Resource<A>, repeatTime: Int, delayTime: TimeInterval, container: RequestCancelContainer, completion: @escaping (OperationCompletion<A>) -> ()) {
		container.requestCancel = self.load(resource: resource) { (result) in
			switch result {
			case .failure(_):
				if repeatTime > 0 {
					DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: {
						self.load(resource: resource, repeatTime: repeatTime - 1, delayTime: delayTime, container: container, completion: completion)
					});
				}else{
					completion(result)
				}
			case .success(_):
				completion(result)
			}
		}
	}
}
