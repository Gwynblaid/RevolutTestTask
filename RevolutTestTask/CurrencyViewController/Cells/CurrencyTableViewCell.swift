// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import UIKit

class CurrencyTableViewCell: UITableViewCell {
	@IBOutlet var iconImageView: UIImageView!
	@IBOutlet var shortTitleLabel: UILabel!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var rateLabel: UILabel!
    
    private static let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 4
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .up
        return numberFormatter
    }()
	
	func configure(with currency: CurrencyRate) {
		iconImageView.image = currency.currency.icon
		shortTitleLabel.text = currency.currency.code
		titleLabel.text = currency.currency.title
        rateLabel.text = CurrencyTableViewCell.numberFormatter.string(from: NSNumber(floatLiteral: currency.price))
	}
}
