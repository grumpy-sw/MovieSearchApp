//
//  DefaultImageRepository.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/26.
//

import Foundation

final class DefaultImageRepository {
    
    private let dataTransferService: SceneDIContainer.Dependencies
    
    init(_ dependencies: SceneDIContainer.Dependencies) {
        self.dataTransferService = dependencies
    }
}

extension DefaultImageRepository: ImageRepository {
    
    func fetchImage(with posterPath: String, width: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        dataTransferService.imageProvider.request(endpoint: EndpointStorage.fetchImageAPI(posterPath, width).endpoint) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
