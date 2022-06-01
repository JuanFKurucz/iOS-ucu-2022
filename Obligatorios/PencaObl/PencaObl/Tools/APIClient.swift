//
//  APIClient.swift
//  APIExercise
//
//  Created by Alvaro Rose on 18/5/22.
//

import Foundation

class APIClient {

    enum Method: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum SessionPolicy {
        case publicDomain, privateDomain
    }
    
    static let shared = APIClient()
    
    private init() { }
    
    @discardableResult private func request(urlString: String,
                                    method: Method = .get,
                                    params: [String: Any] = [:],
                                    sessionPolicy: SessionPolicy = .publicDomain,
                                onCompletion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        
        // 1 - Create URL
        let url: URL
        if [.get].contains(method) {
            // Query params
            var urlComponents = URLComponents(string: urlString)!
            urlComponents.queryItems = params.map { .init(name: $0.key, value: String(describing: $0.value)) }
            url = urlComponents.url!
        } else {
            url = URL(string: urlString)!
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        // Headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if sessionPolicy == .privateDomain {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "userToken") {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Set Authorization header
            } else {
                let userInfo: [String : Any] =
                        [
                            "NSLocalizedDescriptionKey" :  NSLocalizedString("Unauthorized", value: "Token not provided", comment: "") ,
                            "NSLocalizedFailureReasonErrorKey" : NSLocalizedString("Unauthorized", value: "Token not provided", comment: "")
                    ]
                onCompletion(.failure(NSError(domain:"", code:401, userInfo:userInfo)))
            }
        }
        // Body
        if [.post, .put, .delete, .patch].contains(method) {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .sortedKeys)
        }
        let task = URLSession.shared // Get a URLSession
            .dataTask(with: request) { (data, response, error) in // Create a dataTask
                DispatchQueue.main.async {
                    if let error = error {
                        onCompletion(.failure(error))
                    }
                    if let data = data {
                        onCompletion(.success(data))
                    }
                }
            }
        task.resume() // Start the task
        return task
    }
    
    
    @discardableResult func requestItem<T: Decodable>(urlString: String,
                                                      method: Method = .get,
                                                      params: [String: Any] = [:],
                                                      sessionPolicy: SessionPolicy = .privateDomain,
                                                      onCompletion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        
        request(urlString: urlString, method: method, params: params, sessionPolicy: sessionPolicy) { result in
            switch result {
            case .success(let data):
                do {
                    onCompletion(.success(try JSONDecoder().decode(T.self, from: data)))
                } catch {
                    onCompletion(.failure(error))
                }
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
    }
}
