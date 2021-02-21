import Foundation
import NetworkCore

protocol HeroesDetailServicing {
    func saveCharacter(_ character: Character)
    func checkIfFavorite(from character: Character) -> Character?
    func deleteCharacter(_ character: Character)
}

final class HeroesDetailService: HeroesDetailServicing {
    typealias Dependencies = HasDataManager
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func saveCharacter(_ character: Character) {
        do {
            try dependencies.dataManager.save(
                entity: .characters,
                properties: [
                    "id": character.id,
                    "name": character.name,
                    "bio": character.description ?? String(),
                    "path": character.thumbnail.path,
                    "fileExtension": character.thumbnail.fileExtension
                ]
            )
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteCharacter(_ character: Character) {
        do {
            try dependencies.dataManager.delete(entity: .characters, by: (key: "id", value: character.id))
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
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
