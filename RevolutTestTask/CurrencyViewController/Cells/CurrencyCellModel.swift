// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit

struct CurrencyCellModel {
    private let currency: CurrencyRate
    
    init(currency: CurrencyRate) {
        self.currency = currency
    }
}

extension CurrencyCellModel: CellModel {
    private static let cellIdentifier = "CurrencyTableViewCell"
    static func register(in tableView: UITableView) {
        tableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: CurrencyCellModel.cellIdentifier)
    }
    
    var rowHeight: CGFloat {
        return 60
    }
    
    func cell(for tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCellModel.cellIdentifier) as? CurrencyTableViewCell else {
            assert(false, "Cell \"CurrencyTableViewCell\" is not registered in tableView: \(tableView), or class is not kind of \"CurrencyTableViewCell\" class")
            return UITableViewCell(style: .default, reuseIdentifier: nil)
        }
        cell.configure(with: currency)
        return cell
    }
}
