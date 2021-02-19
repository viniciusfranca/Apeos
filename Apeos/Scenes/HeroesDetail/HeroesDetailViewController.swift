import Foundation
import UIKit

protocol HeroesDetailDisplaying: AnyObject { }

final class HeroesDetailViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        return uiImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        return uiLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        return uiLabel
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
        buildLayout()
    }
}

extension HeroesDetailViewController: ViewConfiguration {
    func buildViewHierarchy() { }
    
    func setupConstraints() { }
}

extension HeroesDetailViewController: HeroesDetailDisplaying { }
