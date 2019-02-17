// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation
import UIKit

class CurrencyPickerViewDataSource: NSObject {
    private(set) var selectedCurrency: Currency
    private var currencies: [Currency]
    
    init(selected currency: Currency, currencies: [Currency]) {
        selectedCurrency = currency
        self.currencies = currencies.sorted { $0.code < $1.code }
        super.init()
    }
}

extension CurrencyPickerViewDataSource {
    func reloadData(for pickerView: UIPickerView) {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.reloadAllComponents()
        let row = self.currencies.firstIndex(where: { [unowned self] currency in currency.code == self.selectedCurrency.code }) ?? 0
        pickerView.selectRow(row, inComponent: 0, animated: true)
    }
}

extension CurrencyPickerViewDataSource: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
}

extension CurrencyPickerViewDataSource: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row].code
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = currencies[row]
    }
}

