// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit

struct SectionInfo {
    let title: String
    let height: CGFloat
}

struct Section {
    let info: SectionInfo?
    var models: [CellModel]
}

protocol CellModel {
    static func register(in tableView: UITableView)
    var rowHeight: CGFloat { get }
    func cell(for tableView: UITableView) -> UITableViewCell
}
