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
    
    public func fetchMoviesList(query: String, page: Int, completion: @escaping (Result<MoviesListDTO, NetworkError>) -> Void) -> URLSessionDataTask? {
        dataTransferService.apiProvider.request(endpoint: EndpointStorage.searchAPI(.movie, query, page).endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                guard let moviesList = try? self?.dataTransferService.decoder.decode(MoviesListDTO.self, from: data) else {
                    completion(.failure(.decodeError))
                    return
                }
                completion(.success(moviesList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
