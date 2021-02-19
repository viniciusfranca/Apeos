import Foundation

protocol HeroesPresenting: AnyObject {
    var viewController: HeroesDisplaying? { get set }
    func configureCharacters(from characters: [Character])
}

final class HeroesPresenter {
    weak var viewController: HeroesDisplaying?
}

// MARK: - HeroesPresenting
extension HeroesPresenter: HeroesPresenting {
    func configureCharacters(from characters: [Character]) {
        let viewModels = characters.map { HeroesViewModel(character: $0) }
        viewController?.listCharacters(viewModels: viewModels)
    }
}
