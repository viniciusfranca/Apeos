import Foundation
import UIKit

protocol FeedbackDelegate: AnyObject {
    func didPressButton(_ sender: UIButton)
}

final class FeedbackView: UIView {
    private lazy var imageView: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        uiImageView.contentMode = .scaleAspectFit
        return uiImageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        uiLabel.font = .preferredFont(forTextStyle: .headline)
        uiLabel.numberOfLines = 3
        uiLabel.textAlignment = .center
        return uiLabel
    }()
    
    private lazy var actionButton: UIButton = {
        let uiButton = UIButton(type: .system)
        uiButton.translatesAutoresizingMaskIntoConstraints = false
        uiButton.addTarget(self, action: #selector(pressActionButton(_:)), for: .touchUpInside)
        return uiButton
    }()
    
    weak var delegate: FeedbackDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    func setTextDescription(_ text: String?) {
        descriptionLabel.text = text
    }
    
    func setTitleButton(_ title: String?) {
        actionButton.setTitle(title, for: .normal)
    }
    
    @objc
    private func pressActionButton(_ sender: UIButton) {
        delegate?.didPressButton(sender)
    }
}

extension FeedbackView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(imageView)
        addSubview(descriptionLabel)
        addSubview(actionButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250.0),
            imageView.widthAnchor.constraint(equalToConstant: 250.0)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            actionButton.heightAnchor.constraint(equalToConstant: 48.0),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            actionButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16.0)
        ])
    }
    
    func configureViews() {
        backgroundColor = .systemBackground
    }
}
