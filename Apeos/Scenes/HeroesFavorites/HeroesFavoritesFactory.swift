import Foundation
import UIKit

enum HeroesFavoritesFactory {
    static func make() -> UIViewController {
        let container = DependencyContainer()
        let service = HeroesFavoritesService(dependencies: container)
        let presenter = HeroesFavoritesPresenter()
        let interactor = HeroesFavoritesInteractor(service: service, presenter: presenter)
        let viewController = HeroesFavoritesViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
