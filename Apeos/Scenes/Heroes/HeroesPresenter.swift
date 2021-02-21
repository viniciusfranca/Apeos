import Foundation
import UIKit

protocol HeroesPresenting: AnyObject {
    var viewController: HeroesDisplaying? { get set }
    func configureCharacters(from characters: [Character])
    func updateCharacters(from characters: [Character])
    func startFooterLoading()
    func stopFooterLoading()
    func showError()
    func showEmptyState()
    func showFooterError()
}

final class HeroesPresenter {
    weak var viewController: HeroesDisplaying?
}

// MARK: - HeroesPresenting
extension HeroesPresenter: HeroesPresenting {
    func configureCharacters(from characters: [Character]) {
        viewController?.listCharacters(characters)
    }
    
    func updateCharacters(from characters: [Character]) {
        viewController?.updateCharacters(characters)
    }
    
    func startFooterLoading() {
        viewController?.startFooterLoading()
    }
    
    func stopFooterLoading() {
        viewController?.stopFooterLoading()
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
            titleButton: "Carregar novamente"
        )
    }
    
    func showFooterError() {
        viewController?.showFooterError(from: "Ocorreu um erro ao carregar mais herois")
    }
}
