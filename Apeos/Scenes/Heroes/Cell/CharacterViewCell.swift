import Kingfisher
import UIKit

protocol CharacterDelegate: AnyObject {
    func didPressFavoriteOrUnfavorite(from character: Character)
}

final class CharacterViewCell: UITableViewCell {
    private lazy var containerView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.layer.cornerRadius = 6.0
        uiView.clipsToBounds = true
        return uiView
    }()
    
    private lazy var containerImageView: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        uiImageView.contentMode = .scaleAspectFill
        return uiImageView
    }()
    
    private lazy var overlayView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return uiView
    }()
    
    private lazy var nameLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        uiLabel.font = .preferredFont(forTextStyle: .title1)
        uiLabel.textColor = .white
        return uiLabel
    }()
    
    private lazy var likeButton: UIButton = {
        let uiButton = UIButton()
        uiButton.translatesAutoresizingMaskIntoConstraints = false
        uiButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        uiButton.addTarget(self, action: #selector(pressLikeButton), for: .touchUpInside)
        return uiButton
    }()
    
    private var viewModel: CharacterViewModeling?
    
    weak var delegate: CharacterDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewModel(_ viewModel: CharacterViewModeling) {
        self.viewModel = viewModel
        self.viewModel?.inputs.setupView()
        self.viewModel?.inputs.checkIfFavorites()
    }
    
    // MARK: - Private Methods
    @objc
    private func pressLikeButton() {
        viewModel?.inputs.favoriteOrUnfavorite()
    }
}

extension CharacterViewCell: ViewConfiguration {
    func buildViewHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(containerImageView)
        containerView.addSubview(overlayView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(likeButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 88.0),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4.0)
        ])
        
        NSLayoutConstraint.activate([
            containerImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            containerImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            containerImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            containerImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: containerView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
        ])
        
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: 72.0),
            likeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8.0),
            likeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8.0),
            likeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.0),
        ])
    }
    
    func configureViews() {
        contentView.backgroundColor = .systemBackground
        selectionStyle = .none
    }
}

extension CharacterViewCell: CharacterViewModelOutputs {
    func configureView(name: String) {
        nameLabel.text = name
    }
    
    func configureImage(from url: URL?) {
        containerImageView.kf.setImage(with: url)
    }
    
    func favoriteOrUnfavorite(from character: Character) {
        delegate?.didPressFavoriteOrUnfavorite(from: character)
        viewModel?.inputs.checkIfFavorites()
    }
    
    func updateFavorite(_ isFavorite: Bool) {
        likeButton.tintColor = isFavorite ? .systemYellow : .systemBlue
    }
}
