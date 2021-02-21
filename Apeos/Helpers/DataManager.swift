import CoreData
import Foundation
import UIKit

enum DataManagerError: Error {
    case notConvertData
}

enum DataEntityType: String {
    case characters = "Characters"
}

protocol DataManagerContract {
    func save(entity: DataEntityType, properties: [String: Any]) throws
    func retrieve<T: Decodable>(entity: DataEntityType, from keys: [String]) throws -> T
    func retrieve<T: Decodable>(entity: DataEntityType, by: (key: String, value: Any), from keys: [String]) throws -> T
    func delete(entity: DataEntityType, by: (key: String, value: Any)) throws
}

final class DataManager: DataManagerContract {
    private lazy var persistentContainer: NSPersistentContainer = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unresolved error")
        }
        
        return appDelegate.persistentContainer
    }()
    
    static var shared = DataManager()
    
    func save(entity: DataEntityType, properties: [String: Any]) throws {
        guard
            let entityDescription = NSEntityDescription.entity(forEntityName: entity.rawValue, in: persistentContainer.viewContext)
        else {
            return
        }
        
        let object = NSManagedObject(entity: entityDescription, insertInto: persistentContainer.viewContext)
        properties.forEach { object.setValue($0.value, forKey: $0.key) }
        try persistentContainer.viewContext.save()
    }
    
    func retrieve<T: Decodable>(entity: DataEntityType, from keys: [String]) throws -> T {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        let result = try persistentContainer.viewContext.fetch(fetchRequest)
        guard let objects = result as? [NSManagedObject] else { throw DataManagerError.notConvertData }
        
        var arrayDictionary = [[String: Any?]]()
        
        objects.forEach { object in
            var dictionary = [String: Any?]()
            var customDictionary = [String: Any?]()
            
            keys.forEach { key in
                if key == "path" {
                    customDictionary[key] = object.value(forKey: key)
                    return
                    
                }
                
                if key == "fileExtension" {
                    customDictionary["extension"] = object.value(forKey: key)
                    return
                }
                
                dictionary[key] = object.value(forKey: key)
            }
            
            dictionary["thumbnail"] = customDictionary
            arrayDictionary.append(dictionary)
        }
        let jsonData = try JSONSerialization.data(withJSONObject: arrayDictionary, options: [])
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: jsonData)
    }
    
    func retrieve<T: Decodable>(entity: DataEntityType, by: (key: String, value: Any), from keys: [String]) throws -> T {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        fetchRequest.predicate = NSPredicate(format: "\(by.key) == %@", "\(by.value)")
        
        let result = try persistentContainer.viewContext.fetch(fetchRequest)
        guard let objects = result as? [NSManagedObject] else { throw DataManagerError.notConvertData }
        
        var arrayDictionary = [[String: Any?]]()
        
        objects.forEach { object in
            var dictionary = [String: Any?]()
            var customDictionary = [String: Any?]()
            
            keys.forEach { key in
                if key == "path" {
                    customDictionary[key] = object.value(forKey: key)
                    return
                    
                }
                
                if key == "fileExtension" {
                    customDictionary["extension"] = object.value(forKey: key)
                    return
                }
                
                dictionary[key] = object.value(forKey: key)
            }
            
            dictionary["thumbnail"] = customDictionary
            arrayDictionary.append(dictionary)
        }
        let jsonData = try JSONSerialization.data(withJSONObject: arrayDictionary, options: [])
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: jsonData)
    }
    
    func delete(entity: DataEntityType, by: (key: String, value: Any)) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        fetchRequest.predicate = NSPredicate(format: "\(by.key) == %@", "\(by.value)")
        
        let result = try persistentContainer.viewContext.fetch(fetchRequest)
        
        guard
            let objects = result as? [NSManagedObject],
            let firstObject = objects.first
        else {
            throw DataManagerError.notConvertData
        }
        
        persistentContainer.viewContext.delete(firstObject)
        try persistentContainer.viewContext.save()
    }
}
