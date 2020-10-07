//
//  ApiController.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 06.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ApiController {
    static let shared = ApiController()
    
    func loadData<T: Decodable>(with type: T.Type,endpoint: EndpointProtocol) -> Observable<T> {
        return perform(endpoint)
            .flatMap {
                return URLSession.shared.rx.data(request: $0)
        }.flatMap { [weak self] in
            return self?.parse(from: $0, with: T.self) ?? Observable.error(ApiError.unknownError)
        }
    }
    
    private func perform(_ endpoint: EndpointProtocol) -> Observable<URLRequest> {
        guard var urlComponents = URLComponents(string: endpoint.baseUrl + endpoint.path) else {
            return Observable.error(ApiError.invalidURL)
        }
        
        urlComponents.queryItems = endpoint.params.map({URLQueryItem(name: $0.key, value: $0.value)})
        
        if let url = urlComponents.url {
            return Observable.just(URLRequest(url: url))
        } else {
            return Observable.error(ApiError.invalidURL)
        }
    }
    
    private func parse<T:Decodable>(from data: Data, with type: T.Type) -> Observable<T> {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .secondsSince1970
            let response = try decoder.decode(T.self, from: data)
            return Observable.just(response)
        } catch {
            return Observable.error(ApiError.decodingError)
        }
    }
}
