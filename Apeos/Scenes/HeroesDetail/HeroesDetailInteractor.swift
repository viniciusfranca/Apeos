import Foundation

protocol HeroesDetailInteracting: AnyObject {
    func loadData()
    func favoriteOrUnfavorite()
    func checkIfFavorites()
}

final class HeroesDetailInteractor {
    private let character: Character
    private let presenter: HeroesDetailPresenting
    private let service: HeroesDetailServicing
    
    init(character: Character, presenter: HeroesDetailPresenting, service: HeroesDetailServicing) {
        self.character = character
        self.presenter = presenter
        self.service = service
    }
}

extension HeroesDetailInteractor: HeroesDetailInteracting {
    func loadData() {
        guard
            let url = URL(string: "\(character.thumbnail.path).\(character.thumbnail.fileExtension)")
        else {
            return
        }
        
        presenter.configureView(imageUrl: url, name: character.name, description: character.description ?? String())
    }
    
    func favoriteOrUnfavorite() {
        guard service.checkIfFavorite(from: character) != nil else {
            service.saveCharacter(character)
            checkIfFavorites()
            return
        }
        
        service.deleteCharacter(character)
        checkIfFavorites()
    }
    
    func checkIfFavorites() {
        let isFavorite = service.checkIfFavorite(from: character) != nil
        presenter.updateFavorite(isFavorite)
    }
}
