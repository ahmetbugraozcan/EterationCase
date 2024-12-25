//
//  URLRequestable.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 25.12.2024.
//

import Foundation

// MARK: - URLRequestable Protocol
protocol URLRequestable {
    var path: String { get }
    var method: HTTPMethodType { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }

    func createURLRequest() throws -> URLRequest
}

extension URLRequestable {
    var baseURL: String {
        BaseURLProvider.baseURL
    }
    var headers: [String: String]? { nil }
    var parameters: [String: Any]? { nil }

    func createURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let headers = headers {
            headers.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        if let parameters = parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        }

        return request
    }
}
