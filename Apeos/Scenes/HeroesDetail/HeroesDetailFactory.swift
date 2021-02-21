import Foundation
import UIKit

enum HeroesDetailFactory {
    static func make(character: Character) -> UIViewController {
        let container = DependencyContainer()
        let presenter = HeroesDetailPresenter()
        let service = HeroesDetailService(dependencies: container)
        let interactor = HeroesDetailInteractor(character: character, presenter: presenter, service: service)
        let viewController = HeroesDetailViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
