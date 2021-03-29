//
//  Endpoint.swift
//  
//
//  Created by Ilya Senchukov on 28.03.2021.
//

import Foundation

struct Task: Codable, Equatable {
    var id: Int
    var userId: Int
    var title: String
    var completed: Bool
}

public enum Endpoints {

    static let home = Endpoint<Task>(
        method: .get,
        host: "test",
        path: "")
}

public struct Endpoint<T: Decodable> {

    var method: HTTPMethod = .get
    var host: String
    var path: String
    var parameters: [String: String]? = nil
}
