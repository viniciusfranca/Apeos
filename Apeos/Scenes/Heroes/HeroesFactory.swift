import Foundation
import UIKit

enum HeroesFactory {
    static func make() -> UIViewController {
        let container = DependencyContainer()
        let service = HeroesService(dependencies: container)
        let presenter = HeroesPresenter()
        let interactor = HeroesInteractor(service: service, presenter: presenter)
        let viewController = HeroesViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
