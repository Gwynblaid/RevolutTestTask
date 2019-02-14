// Автор: Sergey Kharchenko
// Описание: Расширение для словаря для удобной работы с запросами.

import Foundation

extension Dictionary {
	//Get-строка из словаря
	var getString: String {
		return self.compactMap({ key, value in
			let stringValue = "\(value)"
			if stringValue.count > 0 {
				return "\(key)".encodedParamForURL + "=" + stringValue.encodedParamForURL
			}
			return nil
		}).joined(separator: "&")
	}
}
