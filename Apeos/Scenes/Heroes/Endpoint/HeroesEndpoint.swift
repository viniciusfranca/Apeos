import CryptoSwift
import Foundation
import NetworkCore

enum HeroesEndpoint: Requestable {
    case characters(numberOfPages: Int)
    
    var baseURL: URL {
        URL(string: "https://gateway.marvel.com/v1/public/")!
    }
    
    var path: String {
        "characters"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: [String : Any] {
        let apikey = "3ba3e7aa5aa6e4809d4fb5a0829295a2"
        let ts = Date().timeIntervalSince1970.description
        let hash = "\(ts)c226bcfe95d703f86b17d93246f756ba4ba58786\(apikey)".md5()
           
        switch self {
        case .characters(let numberOfPages):
            return [
                "offset": numberOfPages,
                "apikey": apikey,
                "hash": hash,
                "ts": ts
            ]
        }
    }
    
    var contentType: ContentType {
        .applicationJson
    }
}
