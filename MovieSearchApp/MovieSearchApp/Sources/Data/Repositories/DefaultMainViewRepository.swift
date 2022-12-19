//
//  DefaultMainViewRepository.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import Foundation

final class DefaultMainViewRepository {
    
    private let dataTransferService: SceneDIContainer.Dependencies
    
    init(_ dependencies: SceneDIContainer.Dependencies) {
        self.dataTransferService = dependencies
    }
}

extension DefaultMainViewRepository: MainViewRepository {
    public func fetchPopularList(media: MediaType, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        dataTransferService.apiProvider.request(endpoint: EndpointStorage.popularAPI(media).endpoint) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetchTrendingList(media: MediaType, timeWindow: TimeWindow, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        dataTransferService.apiProvider.request(endpoint: EndpointStorage.trendingAPI(media, timeWindow).endpoint) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetchUpcomingList(media: MediaType, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        dataTransferService.apiProvider.request(endpoint: EndpointStorage.upcomingAPI(.movie).endpoint) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}
