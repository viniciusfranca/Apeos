import Kingfisher
import UIKit

final class HeroesViewCell: UITableViewCell {
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
        return uiButton
    }()
    
    private var viewModel: HeroesViewModeling?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewModel(_ viewModel: HeroesViewModeling) {
        self.viewModel = viewModel
        self.viewModel?.inputs.setupView()
    }
}

extension HeroesViewCell: ViewConfiguration {
    func buildViewHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(containerImageView)
        containerView.addSubview(overlayView)
        containerView.addSubview(nameLabel)
//        containerView.addSubview(likeButton)
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
    }
    
    func configureViews() {
        contentView.backgroundColor = .systemBackground
        selectionStyle = .none
    }
}

extension HeroesViewCell: HeroesViewModelOutputs {
    func configureView(name: String) {
        nameLabel.text = name
    }
    
    func configureImage(from url: URL?) {
        containerImageView.kf.setImage(with: url)
    }
}
