// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import UIKit

class CurrencyViewController: UIViewController {
	
	lazy private var tableViewDataSource: CurrencyTableViewDataSource = CurrencyTableViewDataSource(dataSource: DataSource(networkHelper: NetworkHelper()), tableView: tableView)
	
    lazy var tableView: UITableView =  {
        let result = UITableView(frame: view.bounds)
        return result
    }()
	
    override func loadView() {
        super.loadView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        let views = ["TableView": tableView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[TableView]-|", options: .init(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[TableView]-|", options: .init(rawValue: 0), metrics: nil, views: views))
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        view.backgroundColor = .white
		tableViewDataSource.reloadData()
		// Do any additional setup after loading the view, typically from a nib.
    }
}

class CurrencyTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
	var dataSource: DataSourceProtocol
	var tableView: UITableView
	
	init(dataSource: DataSourceProtocol, tableView: UITableView) {
		self.dataSource = dataSource
		self.tableView = tableView
		super.init()
		self.dataSource.delegate = self
		tableView.delegate = self
		tableView.dataSource = self
		self.dataSource.register(in: tableView)
	}
	
	func reloadData() {
		dataSource.loadData { result in
			if result {
				DispatchQueue.main.async { [weak self] in
					self?.tableView.reloadData()
				}
			}
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return dataSource.numberOfSections
	}
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       	return dataSource.rows(in: section)
    }
	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource.cellModel(for: indexPath).cell(for: tableView)
    }
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return dataSource.cellModel(for: indexPath).rowHeight
	}
}

extension CurrencyTableViewDataSource: DataSourceDelegate {
	func dataBeginUpdates() {
		tableView.beginUpdates()
	}
	
	func dataReloaded() {
		tableView.reloadData()
	}
	
	func dataChanged(in section: Int) {
		tableView.reloadSections(IndexSet(arrayLiteral: section), with: .automatic)
	}
	
	func dataChanged(at indexPath: IndexPath) {
		tableView.reloadRows(at: [indexPath], with: .automatic)
	}
	
	func dataEndUpdates() {
		tableView.endUpdates()
	}
}

protocol DataSourceDelegate {
	func dataReloaded()
	func dataChanged(in section: Int)
	func dataChanged(at indexPath: IndexPath)
}

protocol DataSourceProtocol {
	var numberOfSections: Int { get }
	var delegate: DataSourceDelegate? { get set }
	
	func register(in tableView: UITableView)
	func rows(in section: Int) -> Int
	
	func loadData(completion: @escaping (Bool) -> ())
	
	func sectionInfo(for section: Int) -> SectionInfo?
	func cellModel(for indexPath: IndexPath) -> CellModel
}

class DataSource: DataSourceProtocol {
	private var sections: [Section] = []
	private var networkHelper: NetworkHelperProtocol
	
	init(networkHelper: NetworkHelperProtocol) {
		self.networkHelper = networkHelper
	}
	
	// MARK: - DataSourceProtocol
	var delegate: DataSourceDelegate?
	
	var numberOfSections: Int {
		return sections.count
	}
	
	func register(in tableView: UITableView) {
		CurrencyCellModel.register(in: tableView)
	}
	
	func rows(in section: Int) -> Int {
		return sections[section].models.count
	}
	
	func sectionInfo(for section: Int) -> SectionInfo? {
		return sections[section].info
	}
	
	func cellModel(for indexPath: IndexPath) -> CellModel {
		return sections[indexPath.section].models[indexPath.row]
	}
	
	func loadData(completion: @escaping (Bool) -> ()) {
		_ = networkHelper.load(resource: Resource<Currency>.currencyGetResource(for: "EUR")) {[weak self] result in
			guard let self = self else { return }
			switch result {
			case .failure(let error):
				print(error)
				DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
					self?.loadData(completion: completion)
				})
			case .success(let currency):
				let cellModels: [CellModel] = currency.rates.compactMap { CurrencyCellModel(currency: $0) }
				self.sections = [Section(info: nil, models: cellModels)]
				completion(true)
			}
		}
	}
}


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
