import Foundation
import UIKit

protocol HeroesFavoritesPresenting: AnyObject {
    var viewController: HeroesFavoritesDisplaying? { get set }
    func configureCharacters(from characters: [Character])
    func showError()
    func showEmptyState()
}

final class HeroesFavoritesPresenter {
    weak var viewController: HeroesFavoritesDisplaying?
}

// MARK: - HeroesPresenting
extension HeroesFavoritesPresenter: HeroesFavoritesPresenting {
    func configureCharacters(from characters: [Character]) {
        viewController?.listCharacters(characters)
    }
        
    func showError() {
        viewController?.showError(
            image: UIImage(named: "ilu_iron_man"),
            description: "Opa! Parece que aconteuce um erro ao buscar todos os herois :(",
            titleButton: "Tentar Novamente"
        )
    }
    
    func showEmptyState() {
        viewController?.showEmptyState(
            image: UIImage(named: "ilu_cap"),
            description: "Que pena! Parece que não tem nenhum heroi no momento",
            titleButton: nil
        )
    }
}
