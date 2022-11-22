
import Foundation

protocol NetworkService: AnyObject {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
}

final class DefaultNetworkService: NetworkService {
    
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        
        guard Reachability.isConnectedToNetwork() else {
            return completion(.failure(NSError.createNetworkError()))
        }
        
        guard var urlComponent = URLComponents(string: request.url) else {
            return completion(.failure(NSError.createError(ofType: ErrorResponse.invalidEndpoint)))
        }
        
        var queryItems: [URLQueryItem] = []
        
        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            return completion(.failure(NSError.createError(ofType: ErrorResponse.invalidQueryItems)))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        
        if request.method == .post {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: request.body, options: JSONSerialization.WritingOptions.prettyPrinted)
            } catch let error {
                return completion(.failure(error))
            }
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse,
                  200..<300 ~= response.statusCode else {
                return completion(.failure(NSError.createError(ofType: ErrorResponse.invalidResponse)))
            }
            
            guard let data = data else {
                return completion(.failure(NSError.createError(ofType: ErrorResponse.noData)))
            }
            
            DispatchQueue.main.async {
                do {
                    let decodedData = try request.decode(data)
                    completion(.success(decodedData))
                } catch let error as NSError {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
}
