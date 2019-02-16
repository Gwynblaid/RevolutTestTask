// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import UIKit

class CurrencyViewController: UIViewController {
	
	private let tableViewDataSource: CurrencyTableViewDataSource
	
	init(tableViewDataSource: CurrencyTableViewDataSource) {
		self.tableViewDataSource = tableViewDataSource
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    lazy var tableView: UITableView =  {
        let result = UITableView(frame: view.bounds)
        result.delegate = tableViewDataSource
        result.dataSource = tableViewDataSource
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
		tableView.reloadData()
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
	func dataBeginUpdates()
	
	func dataReloaded()
	func dataChanged(in section: Int)
	func dataChanged(at indexPath: IndexPath)
	
	func dataEndUpdates()
}

protocol DataSourceProtocol {
	var numberOfSections: Int { get }
	var delegate: DataSourceDelegate? { get set }
	
	func register(in tableView: UITableView)
	func rows(in section: Int) -> Int
	
	func sectionInfo(for section: Int) -> SectionInfo?
	func cellModel(for indexPath: IndexPath) -> CellModel
}

class DataSource {
	private var sections: [Section] = []
	
	func rows(in section: Int) -> Int {
		if section < sections.count {
			return sections[section].models.count
		}
		return 0
	}
}

struct SectionInfo {
	let title: String
	let height: CGFloat
}

struct Section {
	let info: SectionInfo
	var models: [CellModel]
}

protocol CellModel {
	var rowHeight: CGFloat { get }
	func cell(for tableView: UITableView) -> UITableViewCell
}
