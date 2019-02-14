// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import UIKit

class CurrencyViewController: UIViewController {
    
    lazy var tableView: UITableView =  {
        let result = UITableView(frame: view.bounds)
        result.delegate = tableViewDelegate
        result.dataSource = tableViewDataSource
        return result
    }()
    
    lazy var tableViewDelegate = CurrencyTableViewDelegate()
    lazy var tableViewDataSource = CurrencyTableViewDataSource()

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
		// Do any additional setup after loading the view, typically from a nib.
    }
}

class CurrencyTableViewDelegate: NSObject, UITableViewDelegate {
    
}

class CurrencyTableViewDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: nil)
    }
    
    
}
