import Foundation

protocol HeroesDetailPresenting {
    var viewController: HeroesDetailDisplaying? { get set }
}

final class HeroesDetailPresenter {
    weak var viewController: HeroesDetailDisplaying?
}

extension HeroesDetailPresenter: HeroesDetailPresenting {
    
}
