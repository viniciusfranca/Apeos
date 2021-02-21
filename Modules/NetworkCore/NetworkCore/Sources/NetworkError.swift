import Foundation

public enum NetworkError: Error {
    case malformedRequest
    case bodyNotFound
    case badRequest
    case connectionFailure
    case unauthorized
    case notFound
    case tooManyRequests
    case timeout
    case serverError
    case upgradeRequired
    case otherErrors
}
