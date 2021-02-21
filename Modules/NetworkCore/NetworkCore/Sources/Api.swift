import Foundation

public final class Api<Model: Decodable> {
    private let endpoint: Requestable

    public init(endpoint: Requestable) {
        self.endpoint = endpoint
    }

    public func execute(
        session: URLSessionable = URLSession(configuration: .default),
        jsonDecoder: JSONDecoder = JSONDecoder(),
        _ completion: @escaping (Result<Model, Error>) -> Void
    ) {

        var urlComponents = URLComponents(string: endpoint.absoluteString)
        
        if endpoint.method == .get && !endpoint.parameters.isEmpty {
            urlComponents?.queryItems = endpoint.parameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        
        guard let url = urlComponents?.url else {
            return completion(.failure(NetworkError.malformedRequest))
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(endpoint.contentType.rawValue, forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = endpoint.method.rawValue
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.connectionFailure))
                return
            }
            
            let status = HTTPStatusCode(rawValue: httpResponse.statusCode) ?? .processing
            let result = self.evaluateResult(status: status, jsonDecoder: jsonDecoder, responseBody: data)
            completion(result)
        }
        
        task.resume()
    }
    
    private func evaluateResult(
        status: HTTPStatusCode,
        jsonDecoder: JSONDecoder,
        responseBody: Data?
    ) -> Result<Model, Error> {
        
        let result: Result<Model, Error>
        
        switch status {
        case .ok, .created, .accepted, .noContent:
            result = handleSuccess(data: responseBody, jsonDecoder: jsonDecoder)
        case .badRequest, .unprocessableEntity, .preconditionFailed, .preconditionRequired:
            result = .failure(NetworkError.badRequest)
        case .unauthorized:
            result = .failure(NetworkError.unauthorized)
        case .notFound:
            result = .failure(NetworkError.notFound)
        case .tooManyRequests:
            result = .failure(NetworkError.tooManyRequests)
        case .requestTimeout:
            result = .failure(NetworkError.timeout)
        case .internalServerError, .badGateway, .serviceUnavailable:
            result = .failure(NetworkError.serverError)
        case .upgradeRequired:
            result = .failure(NetworkError.upgradeRequired)
        default:
            result = .failure(NetworkError.otherErrors)
        }
        
        return result
    }
    
    private func handleSuccess(data: Data?, jsonDecoder: JSONDecoder) -> Result<Model, Error> {
        guard
            let responseData = data,
            let decoded = try? jsonDecoder.decode(Model.self, from: responseData)
        else {
            return .failure(NetworkError.bodyNotFound)
        }
        
        return .success(decoded)
    }
}
