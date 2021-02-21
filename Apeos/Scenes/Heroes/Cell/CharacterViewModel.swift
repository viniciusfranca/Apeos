import Foundation

protocol CharacterViewModelInputs: AnyObject {
    func setupView()
    func favoriteOrUnfavorite()
    func checkIfFavorites()
    func setupOutputs(_ outputs: CharacterViewModelOutputs?)
}

protocol CharacterViewModelOutputs: AnyObject {
    func configureView(name: String)
    func configureImage(from url: URL?)
    func favoriteOrUnfavorite(from character: Character)
    func updateFavorite(_ isFavorite: Bool)
}

protocol CharacterViewModeling: AnyObject {
    var inputs: CharacterViewModelInputs { get }
    var outputs: CharacterViewModelOutputs? { get set }
}

final class CharacterViewModel: CharacterViewModeling {
    var inputs: CharacterViewModelInputs { self }
    weak var outputs: CharacterViewModelOutputs?
    
    private let character: Character
    private let service: CharacterServicing
    
    init(character: Character, service: CharacterServicing) {
        self.character = character
        self.service = service
    }
}

extension CharacterViewModel: CharacterViewModelInputs {
    func setupView() {
        outputs?.configureView(name: character.name)
        
        guard
            let url = URL(string: "\(character.thumbnail.path).\(character.thumbnail.fileExtension)")
        else {
            return
        }
        outputs?.configureImage(from: url)
    }
    
    func favoriteOrUnfavorite() {
        outputs?.favoriteOrUnfavorite(from: character)
    }
    
    func checkIfFavorites() {
        let isFavorite = service.checkIfFavorite(from: character) != nil
        outputs?.updateFavorite(isFavorite)
    }
    
    func setupOutputs(_ outputs: CharacterViewModelOutputs?) {
        self.outputs = outputs
    }
}
