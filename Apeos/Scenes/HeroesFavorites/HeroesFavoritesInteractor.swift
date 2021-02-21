import Foundation

protocol HeroesFavoritesInteracting: AnyObject {
    func loadData()
    func unfavorite(from character: Character)
}

final class HeroesFavoritesInteractor {
    private let service: HeroesFavoritesServicing
    private let presenter: HeroesFavoritesPresenting

    init(service: HeroesFavoritesServicing, presenter: HeroesFavoritesPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - HeroesInteracting
extension HeroesFavoritesInteractor: HeroesFavoritesInteracting {
    func loadData() {
        service.listCharacters { [weak self] result in
            switch result {
            case let .success(characters) where characters.isEmpty:
                self?.presenter.showEmptyState()
            case .success(let characters):
                self?.presenter.configureCharacters(from: characters)
            case .failure:
                self?.presenter.showError()
            }
        }
    }
    
    func unfavorite(from character: Character) {
        service.deleteCharacter(character)
        loadData()
    }
}
