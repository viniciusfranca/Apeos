import Foundation
import UIKit

protocol HeroesDisplaying: AnyObject {
    func listCharacters(_ characters: [Character])
    func updateCharacters(_ characters: [Character])
    func startFooterLoading()
    func stopFooterLoading()
    func showFooterError(from message: String)
    func showError(image: UIImage?, description: String?, titleButton: String?)
    func showEmptyState(image: UIImage?, description: String?, titleButton: String?)
}

final class HeroesViewController: UIViewController {
    private lazy var feedbackView: FeedbackView = {
        let uiView = FeedbackView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.delegate = self
        return uiView
    }()
    
    private lazy var tableView: UITableView = {
        let uiTableView = UITableView()
        uiTableView.translatesAutoresizingMaskIntoConstraints = false
        uiTableView.rowHeight = UITableView.automaticDimension
        uiTableView.estimatedRowHeight = 88.0
        uiTableView.separatorStyle = .none
        
        uiTableView.register(CharacterViewCell.self, forCellReuseIdentifier: String(describing: CharacterViewCell.self))
        return uiTableView
    }()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search Heroes"
        controller.searchBar.delegate = self
        return controller
    }()
    
    private lazy var adapter: TableViewAdapter<CharacterViewCell, Character> = {
        let adapter = TableViewAdapter<CharacterViewCell, Character>(tableView: tableView)
        
        adapter.itemProvider = { tableView, indexPath, character -> CharacterViewCell? in
            let identifier = String(describing: CharacterViewCell.self)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CharacterViewCell
            
            let container = DependencyContainer()
            let service = CharacterService(dependencies: container)
            let viewModel = CharacterViewModel(character: character, service: service)
            
            cell?.delegate = self
            viewModel.inputs.setupOutputs(cell)
            cell?.setupViewModel(viewModel)
            
            return cell
        }
        
        adapter.itemSelected = { [weak self] tableView, indexPath, character -> Void in
            let controller = HeroesDetailFactory.make(character: character)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        adapter.itemPagination = { [weak self] in
            self?.interactor.loadMoreData()
        }
        
        return adapter
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
        tableView.dataSource = adapter
        tableView.delegate = adapter
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        buildLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.reloadData()
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
    func listCharacters(_ characters: [Character]) {
        adapter.update(items: characters)
        tableView.reloadData()
    }
    
    func updateCharacters(_ characters: [Character]) {
        adapter.add(items: characters)
        tableView.reloadData()
    }
    
    func startFooterLoading() {
        let frame = CGRect(origin: .zero, size: CGSize(width: 80.0, height: 80.0))
        let activityIndicator = UIActivityIndicatorView(frame: frame)
        activityIndicator.startAnimating()
        tableView.tableFooterView = activityIndicator
    }
    
    func stopFooterLoading() {
        tableView.tableFooterView = nil
    }
    
    func showFooterError(from message: String) {
        let frame = CGRect(origin: .zero, size: CGSize(width: .zero, height: 80.0))
        let label = UILabel(frame: frame)
        label.text = message
        label.textAlignment = .center
        tableView.tableFooterView = label
    }
    
    func showError(image: UIImage?, description: String?, titleButton: String?) {
        configureFeedbackView(image: image, description: description, titleButton: titleButton)
    }
    
    func showEmptyState(image: UIImage?, description: String?, titleButton: String?) {
        configureFeedbackView(image: image, description: description, titleButton: titleButton)
    }
    
    // MARK: - Private Methods
    private func configureFeedbackView(image: UIImage?, description: String?, titleButton: String?) {
        feedbackView.setImage(image)
        feedbackView.setTextDescription(description)
        feedbackView.setTitleButton(titleButton)
        
        view.addSubview(feedbackView)
        
        NSLayoutConstraint.activate([
            feedbackView.topAnchor.constraint(equalTo: view.topAnchor),
            feedbackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedbackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedbackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HeroesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        interactor.filterContentForSearch(from: text)
    }
}

extension HeroesViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        interactor.beginSearchEditing()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        interactor.endSearchEditing()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        interactor.initializeCharacters()
    }
}

extension HeroesViewController: FeedbackDelegate {
    func didPressButton(_ sender: UIButton) {
        feedbackView.removeFromSuperview()
        view.constraints.filter { $0.firstItem === feedbackView }.forEach { view.removeConstraint($0) }
        interactor.loadData()
    }
}

extension HeroesViewController: CharacterDelegate {
    func didPressFavoriteOrUnfavorite(from character: Character) {
        interactor.favoriteOrUnfavorite(from: character)
    }
}
