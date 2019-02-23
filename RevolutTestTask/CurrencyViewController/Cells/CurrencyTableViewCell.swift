// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import UIKit

protocol CurrencyCellModelProtocol {
	func cell(_ cell: CurrencyTableViewCell, didChange value: String)
	func validate(value: String) -> Bool
}

class CurrencyTableViewCell: UITableViewCell {
	@IBOutlet private var iconImageView: UIImageView!
	@IBOutlet private var shortTitleLabel: UILabel!
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var rateTextField: UITextField!
	
	private var model: CurrencyCellModelProtocol!
	
	func configure(with currency: CurrencyRate, model: CurrencyCellModelProtocol, multiplier: Double, numberFormatter: NumberFormatter) {
		iconImageView.image = currency.currency.icon
		shortTitleLabel.text = currency.currency.code
		titleLabel.text = currency.currency.title
        rateTextField.text = numberFormatter.string(from: NSNumber(floatLiteral: currency.price * multiplier))
		self.model = model
	}
}

extension CurrencyTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let oldString = (textField.text ?? "") as NSString
		let newString = oldString.replacingCharacters(in: range, with: string)
		return model.validate(value: newString)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField.text?.count ?? 0 > 0 {
			model.cell(self, didChange: textField.text!)
			return true
		}
		return false
	}
}

extension CurrencyTableViewCell: CellActionProtocol {
	func cellSelectedAction() {
		rateTextField.isUserInteractionEnabled = true
		rateTextField.becomeFirstResponder()
	}
}
