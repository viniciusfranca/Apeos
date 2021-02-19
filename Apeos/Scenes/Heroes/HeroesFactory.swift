import Foundation
import UIKit

enum HeroesFactory {
    static func make() -> UIViewController {
        let service = HeroesService()
        let presenter = HeroesPresenter()
        let interactor = HeroesInteractor(service: service, presenter: presenter)
        let viewController = HeroesViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
