//
//  Validator.swift
//  
//
//  Created by Ilya Senchukov on 28.03.2021.
//

import Foundation

protocol Validator {
    func validate(data: Data?, res: URLResponse?, error: Error?) -> NetworkError?
}

class DefaultValidator: Validator {

    func validate(data: Data?, res: URLResponse?, error: Error?) -> NetworkError? {
        if let error = error {
            print(error)
            return .badRequest
        }

        if let res = res as? HTTPURLResponse {
            switch res.statusCode {
                case 400:
                    return .badRequest
                case 401:
                    return .unauthorized
                case 403:
                    return .forbidden
                case 404:
                    return .notFound
                case 405:
                    return .methodNotAllowed
                case 500:
                    return .internalError
                default:
                    break
            }
        }

        return nil
    }
}
