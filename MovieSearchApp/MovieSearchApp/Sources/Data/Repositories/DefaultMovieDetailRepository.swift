//
//  DefaultMovieDetailRepository.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

final class DefaultMovieDetailRepository {
    
    private let dataTransferService: SceneDIContainer.Dependencies
    
    init(_ dependencies: SceneDIContainer.Dependencies) {
        self.dataTransferService = dependencies
    }
}

extension DefaultMovieDetailRepository: MovieDetailRepository {
    func fetchMovieDetails(id: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        dataTransferService.apiProvider.request(endpoint: EndpointStorage.detailAPI(.movie, id).endpoint) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchImageData(width: Int, path: String, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        dataTransferService.imageProvider.request(endpoint: EndpointStorage.fetchImageAPI(path, width).endpoint) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
