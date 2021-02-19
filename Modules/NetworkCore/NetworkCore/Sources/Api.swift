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
            
            guard
                let responseData = data,
                let decoded = try? jsonDecoder.decode(Model.self, from: responseData)
            else {
                return completion(.failure(NetworkError.bodyNotFound))
            }
            
            completion(.success(decoded))
        }
        
        task.resume()
    }
}
