import Foundation

struct Character: Decodable {
    let id: Int
    let name: String
    let description: String?
    let thumbnail: Thumbnail
    
    init(id: Int, name: String, description: String?, thumbnail: Thumbnail) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
    }
}
