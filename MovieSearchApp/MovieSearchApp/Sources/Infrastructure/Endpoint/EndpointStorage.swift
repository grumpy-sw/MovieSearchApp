//
//  EndpointStorage.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/16.
//

import Foundation

enum EndpointStorage {
    fileprivate enum Constants {
        static let baseURL = "https://api.themoviedb.org/3"
        static let imageURL = "https://image.tmdb.org/t/p"
        static let moviePath = "/movie"
        static let tvPath = "/tv"
        static let personPath = "/person"
        
        static let trendingPath = "/trending"
        static let upcomingPath = "/upcoming"
        static let popularPath = "/popular"
        static let searchPath = "/search"
    }
    
    case trendingAPI(_ media: MediaType, _ timeWindow: TimeWindow)
    case upcomingAPI(_ media: MediaType)
    case popularAPI(_ media: MediaType)
    case searchAPI(_ media: MediaType, _ query: String, _ page: Int)
    case detailAPI(_ media: MediaType, _ movieId: Int)
    case fetchImageAPI(_ path: String, _ width: Int)
}

extension EndpointStorage {
    var endpoint: Endpoint {
        switch self {
        case .trendingAPI(let media, let timeWindow):
            return Endpoint(url: "\(Constants.baseURL)\(Constants.trendingPath)\(media.path)\(timeWindow.path)", method: .get, queryParameters: MoviesQuery())
        case .upcomingAPI(let media):
            return Endpoint(url: "\(Constants.baseURL)\(media.path)\(Constants.upcomingPath)", method: .get, queryParameters: MoviesQuery())
        case .popularAPI(let media):
            return Endpoint(url: "\(Constants.baseURL)\(media.path)\(Constants.popularPath)", method: .get, queryParameters: MoviesQuery())
        case .searchAPI(let media, let query, let page):
            return Endpoint(url: "\(Constants.baseURL)\(Constants.searchPath)\(media.path)", method: .get, queryParameters: MovieQuery(page: page, query: query))
        case .detailAPI(let media, let movieId):
            return Endpoint(url: "\(Constants.baseURL)\(media.path)/\(movieId)", method: .get, queryParameters: MoviesQuery())
        case .fetchImageAPI(let path, let width):
            return Endpoint(url: "\(Constants.imageURL)/w\(width)\(path)", method: .get)
        }
    }
}
