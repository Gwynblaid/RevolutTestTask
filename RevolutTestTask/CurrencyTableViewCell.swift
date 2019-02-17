// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import UIKit

class CurrencyTableViewCell: UITableViewCell {
	@IBOutlet var iconImageView: UIImageView!
	@IBOutlet var shortTitleLabel: UILabel!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var rateLabel: UILabel!
	
	func configure(with currency: CurrencyRate) {
		iconImageView.image = currency.icon
		shortTitleLabel.text = currency.shortTitle
		titleLabel.text = currency.title
		rateLabel.text = String(format: "%.4f", currency.price)
	}
}
