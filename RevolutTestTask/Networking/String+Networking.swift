// Автор: Sergey Kharchenko
// Описание: Часто используемые функции для работы со строкой(возможно надо разбить более дескретно)

import Foundation

extension String {
	var encodedParamForURL: String {
		var charset = CharacterSet.urlQueryAllowed
		charset.remove(charactersIn: "&")
		return self.addingPercentEncoding(withAllowedCharacters: charset) ?? ""
	}
}
