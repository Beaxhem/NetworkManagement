//
//  NetworkError.swift
//  
//
//  Created by Ilya Senchukov on 28.03.2021.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case badEndpoint

    // 4xx
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case methodNotAllowed

    // 5xx
    case internalError

    case unknownErrorCode(Int)
}
