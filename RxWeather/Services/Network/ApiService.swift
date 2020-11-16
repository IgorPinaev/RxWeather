//
//  ApiService.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 06.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ApiService {
    private let jsonDecoder: JSONDecoder
    
    init(decoder: JSONDecoder? = nil) {
        if let decoder = decoder {
            jsonDecoder = decoder
        } else {
            jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            jsonDecoder.dateDecodingStrategy = .secondsSince1970
        }
    }
    
    func loadData<T: Decodable>(with type: T.Type, endpoint: EndpointProtocol) -> Observable<T> {
        guard let request = perform(endpoint) else { return .error(ApiError.invalidURL) }
        
        return URLSession.shared.rx.data(request: request)
            .map { [weak self] data -> T in
                guard let self = self else { throw ApiError.dataNil }
                return try self.parse(from: data, with: T.self)
        }
    }
    
    private func perform(_ endpoint: EndpointProtocol) -> URLRequest? {
        guard var urlComponents = URLComponents(string: endpoint.baseUrl + endpoint.path) else {
            return nil
        }
        
        urlComponents.queryItems = endpoint.params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
    
    private func parse<T:Decodable>(from data: Data, with type: T.Type) throws -> T {
        return try jsonDecoder.decode(type, from: data)
    }
}
