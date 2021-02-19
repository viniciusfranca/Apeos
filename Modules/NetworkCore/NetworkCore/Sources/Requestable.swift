import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum ContentType {
    case applicationJson
    case textHtml
    case textPlain
    case textXml
    
    public var rawValue: String {
        switch self {
        case .applicationJson:
            return "application/json"
        case .textHtml:
            return "text/html"
        case .textPlain:
            return "text/plain"
        case .textXml:
            return "text/xml"
        }
    }
}

public protocol Requestable {
    var baseURL: URL { get }
    var path: String { get }
    var absoluteString: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var contentType: ContentType { get }
}

extension Requestable {
    public var absoluteString: String {
        let safeBaseUrl = baseURL.absoluteString.hasSuffix("/") ? String(baseURL.absoluteString.dropLast()) : baseURL.absoluteString
        let safePath = path.starts(with: "/") ? String(path.dropFirst()) : path
        return "\(safeBaseUrl)/\(safePath)"
    }
}
