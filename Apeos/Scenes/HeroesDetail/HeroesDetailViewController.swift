import Foundation
import Kingfisher
import UIKit

protocol HeroesDetailDisplaying: AnyObject {
    func configureView(imageUrl: URL, name: String, description: String)
    func configureFavorite(from title: String)
}

final class HeroesDetailViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        uiImageView.layer.cornerRadius = 100.0
        uiImageView.clipsToBounds = true
        return uiImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        uiLabel.textAlignment = .center
        uiLabel.font = .preferredFont(forTextStyle: .largeTitle)
        uiLabel.numberOfLines = 0
        return uiLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        uiLabel.numberOfLines = 0
        return uiLabel
    }()
    
    private lazy var favoriteButton: UIButton = {
        let uiButton = UIButton(type: .system)
        uiButton.translatesAutoresizingMaskIntoConstraints = false
        uiButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        uiButton.setTitle("Favorite", for: .normal)
        uiButton.addTarget(self, action: #selector(pressFavorite(_:)), for: .touchUpInside)
        return uiButton
    }()
    
    private let interactor: HeroesDetailInteracting
    
    init(interactor: HeroesDetailInteracting) {
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
        interactor.checkIfFavorites()
        buildLayout()
    }
    
    // MARK: - Private Methods
    @objc
    private func pressFavorite(_ sender: UIButton) {
        interactor.favoriteOrUnfavorite()
    }
}

extension HeroesDetailViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(favoriteButton)
        view.addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 200.0),
            imageView.heightAnchor.constraint(equalToConstant: 200.0),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.0),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            favoriteButton.heightAnchor.constraint(equalToConstant: 48.0),
            favoriteButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16.0),
            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: 16.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0)
        ])
        
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    func configureViews() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension HeroesDetailViewController: HeroesDetailDisplaying {
    func configureView(imageUrl: URL, name: String, description: String) {
        imageView.kf.setImage(with: imageUrl)
        nameLabel.text = name
        descriptionLabel.text = description
    }
    
    func configureFavorite(from title: String) {
        favoriteButton.setTitle(title, for: .normal)
    }
}
