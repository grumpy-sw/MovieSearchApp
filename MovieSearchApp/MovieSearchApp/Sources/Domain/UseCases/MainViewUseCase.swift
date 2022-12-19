//
//  MainViewUseCase.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import Foundation

protocol MainViewUseCase {
    func fetchPopularList(query: MoviesQuery, media: MediaType)
    func fetchTrendingList(query: MoviesQuery, media: MediaType, timeWindow: TimeWindow)
    func fetchUpcomingList(query: MoviesQuery, media: MediaType)
}

final class DefaultMainViewUseCase: MainViewUseCase {
    
    private let mainViewRepository: MainViewRepository
    
    init(mainViewRepository: MainViewRepository) {
        self.mainViewRepository = mainViewRepository
    }
    
    func fetchPopularList(query: MoviesQuery, media: MediaType) {
        mainViewRepository.fetchPopularList(query: query, media: media)
    }
    
    func fetchTrendingList(query: MoviesQuery, media: MediaType, timeWindow: TimeWindow) {
        mainViewRepository.fetchTrendingList(query: query, media: media, timeWindow: timeWindow)
    }
    
    func fetchUpcomingList(query: MoviesQuery, media: MediaType) {
        mainViewRepository.fetchUpcomingList(query: query, media: media)
    }
}
