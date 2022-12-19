//
//  MainViewRepository.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import Foundation

protocol MainViewRepository {
    @discardableResult
    func fetchPopularList(query: MoviesQuery, media: MediaType)
    func fetchTrendingList(query: MoviesQuery, media: MediaType, timeWindow: TimeWindow)
    func fetchUpcomingList(query: MoviesQuery, media: MediaType)
}
