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
