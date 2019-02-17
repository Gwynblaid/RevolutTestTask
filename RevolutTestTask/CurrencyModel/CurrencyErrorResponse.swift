// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import ObjectMapper

struct CurrencyErrorResponse: Error {
    let description: String
}

extension CurrencyErrorResponse: ImmutableMappable {
    init(map: Map) throws {
        description = try map.value("error")
    }
}
