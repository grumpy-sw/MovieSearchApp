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
    public func fetchPopularList(media: MediaType, completion: @escaping (Result<MovieCollection, NetworkError>) -> Void) -> URLSessionDataTask? {
        dataTransferService.apiProvider.request(endpoint: EndpointStorage.popularAPI(media).endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                guard let movieCollection = try? self?.dataTransferService.decoder.decode(MovieCollectionDTO.self, from: data) else {
                    completion(.failure(.decodeError))
                    return
                }
                completion(.success(movieCollection.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetchTrendingList(media: MediaType, timeWindow: TimeWindow, completion: @escaping (Result<MovieCollection, NetworkError>) -> Void) -> URLSessionDataTask? {
        dataTransferService.apiProvider.request(endpoint: EndpointStorage.trendingAPI(media, timeWindow).endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                guard let movieCollection = try? self?.dataTransferService.decoder.decode(MovieCollectionDTO.self, from: data) else {
                    completion(.failure(.decodeError))
                    return
                }
                completion(.success(movieCollection.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetchUpcomingList(media: MediaType, completion: @escaping (Result<MovieCollection, NetworkError>) -> Void) -> URLSessionDataTask? {
        dataTransferService.apiProvider.request(endpoint: EndpointStorage.upcomingAPI(.movie).endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                guard let movieCollection = try? self?.dataTransferService.decoder.decode(MovieCollectionDTO.self, from: data) else {
                    completion(.failure(.decodeError))
                    return
                }
                completion(.success(movieCollection.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
