import Foundation
import NetworkCore

protocol CharacterServicing {
    func checkIfFavorite(from character: Character) -> Character?
}

final class CharacterService: CharacterServicing {
    typealias Dependencies = HasDataManager
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func checkIfFavorite(from character: Character) -> Character? {
        do {
            let characters: [Character] = try dependencies.dataManager.retrieve(
                entity: .characters,
                by: (key: "id", value: character.id),
                from: ["id", "name", "bio", "path", "fileExtension"]
            )
            
            return characters.first
        } catch {
            return nil
        }
    }
}
