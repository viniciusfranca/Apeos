import Foundation
import UIKit

enum HeroesDetailFactory {
    static func make(character: Character) -> UIViewController {
        let presenter = HeroesDetailPresenter()
        let interactor = HeroesDetailInteractor(character: character, presenter: presenter)
        let viewController = HeroesDetailViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
