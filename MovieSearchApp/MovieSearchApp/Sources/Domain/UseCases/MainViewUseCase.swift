//
//  MainViewUseCase.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import Foundation

protocol MainViewUseCase {
    func executeFetchPopular(query: MoviesQuery, media: MediaType, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
    func executeFetchTrending(query: MoviesQuery, media: MediaType, timeWindow: TimeWindow, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
    func executeFetchUpcoming(query: MoviesQuery, media: MediaType, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
}

final class DefaultMainViewUseCase: MainViewUseCase {
    
    private let mainViewRepository: MainViewRepository
    
    init(mainViewRepository: MainViewRepository) {
        self.mainViewRepository = mainViewRepository
    }
    
    func executeFetchPopular(query: MoviesQuery, media: MediaType, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        mainViewRepository.fetchPopularList(query: query, media: media) { result in
            completion(result)
        }
    }
    
    func executeFetchTrending(query: MoviesQuery, media: MediaType, timeWindow: TimeWindow, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        mainViewRepository.fetchTrendingList(query: query, media: media, timeWindow: timeWindow) { result in
            completion(result)
        }
    }
    
    func executeFetchUpcoming(query: MoviesQuery, media: MediaType, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        mainViewRepository.fetchUpcomingList(query: query, media: media) { result in
            completion(result)
        }
    }
}
