//
//  MainViewRepository.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import Foundation

protocol MainViewRepository {
    @discardableResult
    func fetchPopularList(media: MediaType, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
    func fetchTrendingList(media: MediaType, timeWindow: TimeWindow, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
    func fetchUpcomingList(media: MediaType, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
}
