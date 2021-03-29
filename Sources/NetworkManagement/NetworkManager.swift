//
//  NetworkManager.swift
//
//
//  Created by Ilya Senchukov on 28.03.2021.
//

import Foundation
import UIKit

public class NetworkManager {

    @discardableResult
    public func dataTask<T: Decodable>(
        endpoint: Endpoint<T>,
        validator: Validator = DefaultValidator(),
        completion: @escaping (Result<T, NetworkError>) -> Void) -> URLSessionDataTask? {

        guard let request = getRequest(endpoint: endpoint) else {
            completion(.failure(.badEndpoint))
            return nil
        }

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, res, error in
            guard let self = self else {
                return
            }

            if let validatorError = validator.validate(data: data, res: res, error: error) {
                completion(.failure(validatorError))
            }

            guard let data = data else {
                return
            }

            if T.self == Data.self {
                guard let data = data as? T else {
                    completion(.failure(.badEndpoint))
                    return
                }

                completion(.success(data))
            } else {

                do {
                    let data = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(data))
                } catch {
                    let error = self.mapError(error)
                    completion(.failure(error))
                }
            }
        }

        task.resume()

        return task
    }

    @discardableResult
    func dataTask<T: Decodable>(
        url: URL,
        validator: Validator = DefaultValidator(),
        completion: @escaping (Result<T, NetworkError>) -> Void) -> URLSessionDataTask? {

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, res, error in
            guard let self = self else {
                return
            }

            if let validatorError = validator.validate(data: data, res: res, error: error) {
                completion(.failure(validatorError))
            }

            guard let data = data else {
                return
            }

            if T.self == Data.self {
                guard let data = data as? T else {
                    completion(.failure(.badEndpoint))
                    return
                }

                completion(.success(data))
            } else {

                do {
                    let data = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(data))
                } catch {
                    let error = self.mapError(error)
                    completion(.failure(error))
                }
            }
        }

        task.resume()

        return task
    }
}

private extension NetworkManager {

    func getRequest<T: Decodable>(endpoint: Endpoint<T>) -> URLRequest? {

        guard var urlComponents = URLComponents(string: endpoint.host) else {
            return nil
        }

        urlComponents.path = endpoint.path

        if let parameters = endpoint.parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        }

        guard let url = urlComponents.url, verifyURL(url) else {
            return nil
        }

        let request = URLRequest(url: url)

        return request
    }

    func mapError(_ error: Error) -> NetworkError {
        return .badEndpoint
    }

    func verifyURL(_ url: URL) -> Bool {
        if let _ = URL(string: url.absoluteString) {
            return true
        }

        return false
    }
}
