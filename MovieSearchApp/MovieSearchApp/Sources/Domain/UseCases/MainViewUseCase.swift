//
//  MainViewUseCase.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import Foundation

protocol MainViewUseCase {
    func executeFetchPopular(media: MediaType, completion: @escaping (Result<MovieCollection, NetworkError>) -> Void) -> URLSessionDataTask?
    func executeFetchTrending(media: MediaType, timeWindow: TimeWindow, completion: @escaping (Result<MovieCollection, NetworkError>) -> Void) -> URLSessionDataTask?
    func executeFetchUpcoming(media: MediaType, completion: @escaping (Result<MovieCollection, NetworkError>) -> Void) -> URLSessionDataTask?
}

final class DefaultMainViewUseCase: MainViewUseCase {
    
    private let mainViewRepository: MainViewRepository
    
    init(mainViewRepository: MainViewRepository) {
        self.mainViewRepository = mainViewRepository
    }
    
    func executeFetchPopular(media: MediaType, completion: @escaping (Result<MovieCollection, NetworkError>) -> Void) -> URLSessionDataTask? {
        mainViewRepository.fetchPopularList(media: media) { result in
            switch result {
            case .success(let movieCollection):
                completion(.success(movieCollection))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func executeFetchTrending(media: MediaType, timeWindow: TimeWindow, completion: @escaping (Result<MovieCollection, NetworkError>) -> Void) -> URLSessionDataTask? {
        mainViewRepository.fetchTrendingList(media: media, timeWindow: timeWindow) { result in
            switch result {
            case .success(let movieCollection):
                completion(.success(movieCollection))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func executeFetchUpcoming(media: MediaType, completion: @escaping (Result<MovieCollection, NetworkError>) -> Void) -> URLSessionDataTask? {
        mainViewRepository.fetchUpcomingList(media: media) { result in
            switch result {
            case .success(let movieCollection):
                completion(.success(movieCollection))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
