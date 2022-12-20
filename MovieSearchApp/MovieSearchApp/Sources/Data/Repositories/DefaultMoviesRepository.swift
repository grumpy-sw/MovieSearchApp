//
//  DefaultMoviesRepository.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/20.
//

import Foundation

final class DefaultMoviesRepository {
    
    private let dataTransferService: SceneDIContainer.Dependencies
    
    init(_ dependencies: SceneDIContainer.Dependencies) {
        self.dataTransferService = dependencies
    }
}

extension DefaultMoviesRepository: MoviesRepository {
    
    public func fetchMoviesList(query: MovieQuery, page: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        dataTransferService.apiProvider.request(endpoint: EndpointStorage.searchAPI(.movie, query.query, page).endpoint) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
