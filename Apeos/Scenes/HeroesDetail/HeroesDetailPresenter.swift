import Foundation

protocol HeroesDetailPresenting {
    var viewController: HeroesDetailDisplaying? { get set }
    func configureView(imageUrl: URL, name: String, description: String)
    func updateFavorite(_ isFavorite: Bool)
}

final class HeroesDetailPresenter {
    weak var viewController: HeroesDetailDisplaying?
}

extension HeroesDetailPresenter: HeroesDetailPresenting {
    func configureView(imageUrl: URL, name: String, description: String) {
        viewController?.configureView(imageUrl: imageUrl, name: name, description: description)
    }
    
    func updateFavorite(_ isFavorite: Bool) {
        viewController?.configureFavorite(from: isFavorite ? "Favoritado" : "Favoritar")
    }
}
