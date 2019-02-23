// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit

protocol CurrencyCellModelDelegate: class {
	func cellModel(_ cellModel: CurrencyCellModel, didChanged value: Double)
}

struct CurrencyCellModel {
    private let currency: CurrencyRate
	private var delegate: CurrencyCellModelDelegate?
	private let multiplier: Double
    
	init(currency: CurrencyRate, multiplier: Double, delegate: CurrencyCellModelDelegate?) {
        self.currency = currency
		self.delegate = delegate
		self.multiplier = multiplier
    }
}

extension CurrencyCellModel: CellModel {
	private static let numberFormatter: NumberFormatter = {
		let numberFormatter = NumberFormatter()
		numberFormatter.maximumFractionDigits = 4
		numberFormatter.numberStyle = .decimal
		numberFormatter.roundingMode = .up
		return numberFormatter
	}()
	
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
		cell.configure(with: currency, model: self, multiplier: multiplier, numberFormatter: CurrencyCellModel.numberFormatter)
        return cell
    }
}

extension CurrencyCellModel: CurrencyCellModelProtocol {
	func validate(value: String) -> Bool {
		let validationString = value.count > 0 ? value : "0"
		if let number = CurrencyCellModel.numberFormatter.number(from: validationString) {
			delegate?.cellModel(self, didChanged: number.doubleValue)
			return true
		}
		return false
	}
	
	func cell(_ cell: CurrencyTableViewCell, didChange value: String) {
		guard let doubleValue = Double(value) else {
			print("Need add validation to text field")
			return
		}
		delegate?.cellModel(self, didChanged: doubleValue)
	}
}
