import Foundation
import UIKit

protocol HeroesDisplaying: AnyObject {
    func listCharacters(viewModels: [HeroesViewModeling])
}

final class TableViewDataSource<Cell, Item>: NSObject, UITableViewDataSource where Cell: UITableViewCell {
    public typealias ItemProvider = (_ tableView: UITableView, _ indexPath: IndexPath, _ item: Item) -> Cell?
    
    public var itemProvider: ItemProvider?
    
    private let tableView: UITableView
    private var data = [Item]()
    
    init(tableView: UITableView, itemProvider: ItemProvider? = nil) {
        self.tableView = tableView
        self.itemProvider = itemProvider
    }
    
    func add(items: [Item]) {
        data = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.row]
        
        guard let cell = itemProvider?(tableView, indexPath, item) else {
            return UITableViewCell()
        }
        
        return cell
    }
}

final class HeroesViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let uiTableView = UITableView()
        uiTableView.translatesAutoresizingMaskIntoConstraints = false
        uiTableView.rowHeight = UITableView.automaticDimension
        uiTableView.estimatedRowHeight = 88.0
        uiTableView.separatorStyle = .none
        
        uiTableView.register(HeroesViewCell.self, forCellReuseIdentifier: String(describing: HeroesViewCell.self))
        return uiTableView
    }()
    
    private lazy var dataSource: TableViewDataSource<HeroesViewCell, HeroesViewModeling> = {
        let dataSource = TableViewDataSource<HeroesViewCell, HeroesViewModeling>(tableView: tableView)
        dataSource.itemProvider = { tableView, indexPath, viewModel -> HeroesViewCell? in
            let identifier = String(describing: HeroesViewCell.self)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? HeroesViewCell
            viewModel.inputs.setupOutputs(cell)
            cell?.setupViewModel(viewModel)
            return cell
        }
        
        return dataSource
    }()
    
    private let interactor: HeroesInteracting
    
    init(interactor: HeroesInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadData()
        tableView.dataSource = dataSource
        buildLayout()
    }
}

extension HeroesViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureViews() {
        title = "Heroes"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension HeroesViewController: HeroesDisplaying {
    func listCharacters(viewModels: [HeroesViewModeling]) {
        dataSource.add(items: viewModels)
        tableView.reloadData()
    }
}
