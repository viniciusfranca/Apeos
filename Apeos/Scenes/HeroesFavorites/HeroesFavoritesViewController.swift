import Foundation
import UIKit

protocol HeroesFavoritesDisplaying: AnyObject {
    func listCharacters(_ characters: [Character])
    func showError(image: UIImage?, description: String?, titleButton: String?)
    func showEmptyState(image: UIImage?, description: String?, titleButton: String?)
}

final class HeroesFavoritesViewController: UIViewController {
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
        
        return adapter
    }()
    
    private let interactor: HeroesFavoritesInteracting
    
    init(interactor: HeroesFavoritesInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = adapter
        tableView.delegate = adapter
        buildLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.loadData()
    }
}

extension HeroesFavoritesViewController: ViewConfiguration {
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
        title = "Favorites"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension HeroesFavoritesViewController: HeroesFavoritesDisplaying {
    func listCharacters(_ characters: [Character]) {
        if view.subviews.contains(feedbackView) {
            feedbackView.removeFromSuperview()
            view.constraints.filter { $0.firstItem === feedbackView }.forEach { view.removeConstraint($0) }
        }
        
        adapter.update(items: characters)
        tableView.reloadData()
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

extension HeroesFavoritesViewController: FeedbackDelegate {
    func didPressButton(_ sender: UIButton) {
        feedbackView.removeFromSuperview()
        view.constraints.filter { $0.firstItem === feedbackView }.forEach { view.removeConstraint($0) }
        interactor.loadData()
    }
}

extension HeroesFavoritesViewController: CharacterDelegate {
    func didPressFavoriteOrUnfavorite(from character: Character) {
        interactor.unfavorite(from: character)
    }
}
