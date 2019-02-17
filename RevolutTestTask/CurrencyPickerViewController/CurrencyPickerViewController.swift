// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import UIKit

protocol CurrencyPickerViewControllerDelegate: class {
    func currencyPickerViewController(_ controller: CurrencyPickerViewController, didSelect currency: Currency)
}

class CurrencyPickerViewController: UIViewController {
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: .zero)
        return pickerView
    }()
    
    weak var delegate: CurrencyPickerViewControllerDelegate?
    
    private let pickerDataSource: CurrencyPickerViewDataSource!
    
    init(selected: Currency, availiable: [Currency]) {
        pickerDataSource = CurrencyPickerViewDataSource(selected: selected, currencies: availiable)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerView)
        let views = ["pickerView": pickerView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pickerView]-0-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[pickerView(300)]-0-|", options: [], metrics: nil, views: views))
        pickerView.backgroundColor = .white
        
        let doneButton = UIButton(type: .custom)
        doneButton.setTitle("Done", for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)
        
        doneButton.rightAnchor.constraint(equalTo: pickerView.rightAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: pickerView.topAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        
        doneButton.setTitleColor(.blue, for: .normal)
        doneButton.addTarget(self, action: #selector(doneTapped(_:)), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        pickerDataSource.reloadData(for: pickerView)
    }
}

extension CurrencyPickerViewController {
    @IBAction func doneTapped(_ sender: Any?) {
        delegate?.currencyPickerViewController(self, didSelect: pickerDataSource.selectedCurrency)
    }
}
