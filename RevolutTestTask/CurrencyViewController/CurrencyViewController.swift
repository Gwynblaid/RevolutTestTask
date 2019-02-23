// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import UIKit

class CurrencyViewController: UIViewController {
	lazy private var interactor: CurrencyViewControllerInteractor = CurrencyViewControllerInteractor(dataSource: CurrenciesDataSource(networkHelper: NetworkHelper(), refreshTimeInterval: 1), tableView: tableView)
	
    private lazy var tableView: UITableView = UITableView(frame: view.bounds)
    private lazy var currencyButton = UIButton(type: .custom)
	
    override func loadView() {
        super.loadView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        let views = ["TableView": tableView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[TableView]-|", options: .init(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[TableView]-|", options: .init(rawValue: 0), metrics: nil, views: views))
        currencyButton.setTitleColor(.black, for: .normal)
        currencyButton.frame = .init(x: 0, y: 0, width: 120, height: 40)
        navigationItem.titleView = currencyButton
        currencyButton.addTarget(self, action: #selector(changeCurrenCurrencyTapped(_:)), for: .touchUpInside)
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        view.backgroundColor = .white
		interactor.reloadData()
		// Do any additional setup after loading the view, typically from a nib.
    }
}

// MARK: - Actions
extension CurrencyViewController {
    @IBAction func changeCurrenCurrencyTapped(_ sender: Any?) {
//        let viewController = CurrencyPickerViewController(selected: interactor.currentCurrency, availiable: interactor.availiableCurrecies)
//        viewController.modalPresentationStyle = .overFullScreen
//        viewController.delegate = self
//        present(viewController, animated: false)
    }
}

//// MARK - CurrencyPickerViewControllerDelegate
//extension CurrencyViewController: CurrencyPickerViewControllerDelegate {
//    func currencyPickerViewController(_ controller: CurrencyPickerViewController, didSelect currency: Currency) {
//        interactor.currentCurrency = currency
//        currencyButton.setTitle(currency.code, for: .normal)
//        interactor.reloadData()
//        controller.dismiss(animated: false)
//    }
//}
