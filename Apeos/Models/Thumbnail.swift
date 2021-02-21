import Foundation

struct Thumbnail: Decodable {
    let path: String
    let fileExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case fileExtension = "extension"
    }
    
    init(path: String, fileExtension: String) {
        self.path = path
        self.fileExtension = fileExtension
    }
}
