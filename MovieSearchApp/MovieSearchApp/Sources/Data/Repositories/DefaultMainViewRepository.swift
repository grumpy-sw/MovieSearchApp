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
    public func fetchPopularList(query: MoviesQuery, media: MediaType) {
        dataTransferService.apiProvider.request(endpoint: EndpointStorage.popularAPI(media).endpoint) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    public func fetchTrendingList(query: MoviesQuery, media: MediaType, timeWindow: TimeWindow) {
        dataTransferService.apiProvider.request(endpoint: EndpointStorage.trendingAPI(media, timeWindow).endpoint) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    public func fetchUpcomingList(query: MoviesQuery, media: MediaType) {
        dataTransferService.apiProvider.request(endpoint: EndpointStorage.upcomingAPI(.movie).endpoint) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.errorDescription)
            }
        }
        
    }
}
