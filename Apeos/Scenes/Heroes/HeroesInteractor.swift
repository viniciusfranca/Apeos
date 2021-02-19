import Foundation

protocol HeroesInteracting: AnyObject {
    func loadData()
}

final class HeroesInteractor {
    private var numberOfPages: Int = 0
    
    private let service: HeroesServicing
    private let presenter: HeroesPresenting

    init(service: HeroesServicing, presenter: HeroesPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - HeroesInteracting
extension HeroesInteractor: HeroesInteracting {
    func loadData() {
        service.listCharacters(from: numberOfPages) { [weak self] result in
            switch result {
            case .success(let response):
                self?.presenter.configureCharacters(from: response.data.results)
            case .failure(let error):
                print(error)
            }
        }
    }
}
