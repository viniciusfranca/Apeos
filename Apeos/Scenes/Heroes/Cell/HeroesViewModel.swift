import Foundation

protocol HeroesViewModelInputs: AnyObject {
    func setupView()
    func setupOutputs(_ outputs: HeroesViewModelOutputs?)
}

protocol HeroesViewModelOutputs: AnyObject {
    func configureView(name: String)
    func configureImage(from url: URL?)
}

protocol HeroesViewModeling: AnyObject {
    var inputs: HeroesViewModelInputs { get }
    var outputs: HeroesViewModelOutputs? { get set }
}

final class HeroesViewModel: HeroesViewModeling {
    var inputs: HeroesViewModelInputs { self }
    weak var outputs: HeroesViewModelOutputs?
    
    private let character: Character
    
    init(character: Character) {
        self.character = character
    }
}

extension HeroesViewModel: HeroesViewModelInputs {
    func setupView() {
        outputs?.configureView(name: character.name)
        
        guard
            let url = URL(string: "\(character.thumbnail.path).\(character.thumbnail.fileExtension)")
        else {
            return
        }
        outputs?.configureImage(from: url)
    }
    
    func setupOutputs(_ outputs: HeroesViewModelOutputs?) {
        self.outputs = outputs
    }
}
