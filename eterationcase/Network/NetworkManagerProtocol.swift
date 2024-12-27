//
//  NetworkManagerProtocol.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 25.12.2024.
//

// MARK: - NetworkManagerProtocol
protocol NetworkManagerProtocol {
    func request<T: Decodable, V: URLRequestable>(
        requestable: V,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}
