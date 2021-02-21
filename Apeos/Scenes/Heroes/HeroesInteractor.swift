import Foundation

protocol HeroesInteracting: AnyObject {
    func loadData()
    func reloadData()
    func loadMoreData()
    func initializeCharacters()
    func filterContentForSearch(from text: String)
    func favoriteOrUnfavorite(from character: Character)
    func beginSearchEditing()
    func endSearchEditing()
}

final class HeroesInteractor {
    private var isNeededLoadData = true
    private var isSearch = false
    
    private var numberOfPages: Int = 0
    
    private let service: HeroesServicing
    private let presenter: HeroesPresenting
    
    private var characters = [Character]()

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
            case let .success(response) where response.data.results.isEmpty:
                self?.presenter.showEmptyState()
            case .success(let response):
                self?.numberOfPages += response.data.count
                self?.characters.append(contentsOf: response.data.results)
                self?.presenter.configureCharacters(from: response.data.results)
            case .failure:
                self?.presenter.showError()
            }
        }
    }
    
    func reloadData() {
        guard !isSearch else { return }
        presenter.configureCharacters(from: characters)
    }
    
    func loadMoreData() {
        guard isNeededLoadData else { return }
        
        isNeededLoadData = false
        
        presenter.startFooterLoading()
        
        service.listCharacters(from: numberOfPages) { [weak self] result in
            self?.isNeededLoadData = true
            self?.presenter.stopFooterLoading()
            switch result {
            case .success(let response):
                self?.numberOfPages += response.data.count
                self?.characters.append(contentsOf: response.data.results)
                self?.presenter.updateCharacters(from: response.data.results)
            case .failure:
                self?.presenter.showFooterError()
            }
        }
    }
    
    func initializeCharacters() {
        numberOfPages = characters.count
        presenter.configureCharacters(from: characters)
    }
    
    func filterContentForSearch(from text: String) {
        guard !text.isEmpty else { return }
        
        let filterCharacters = characters.filter { $0.name.lowercased().contains(text.lowercased()) }
        presenter.configureCharacters(from: filterCharacters)
    }
    
    func favoriteOrUnfavorite(from character: Character) {
        guard service.checkIfFavorite(from: character) != nil else {
            service.saveCharacter(character)
            return
        }
        
        service.deleteCharacter(character)
    }
    
    func beginSearchEditing() {
        isSearch = true
    }
    
    func endSearchEditing() {
        isSearch = false
    }
}
