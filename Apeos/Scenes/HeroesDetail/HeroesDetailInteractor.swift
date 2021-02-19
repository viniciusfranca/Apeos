import Foundation

protocol HeroesDetailInteracting: AnyObject {
    func loadData()
}

final class HeroesDetailInteractor {
    private let character: Character
    private let presenter: HeroesDetailPresenting
    
    init(character: Character, presenter: HeroesDetailPresenting) {
        self.character = character
        self.presenter = presenter
    }
}

extension HeroesDetailInteractor: HeroesDetailInteracting {
    func loadData() { }
}
