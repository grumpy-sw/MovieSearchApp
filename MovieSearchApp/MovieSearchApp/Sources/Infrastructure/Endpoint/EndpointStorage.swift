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
        static let moviePath = "/movie"
        static let tvPath = "/tv"
        static let personPath = "/person"
        
        static let trendingPath = "/trending"
        static let upcomingPath = "/upcoming"
        static let popularPath = "/popular"
    }
    
    case trendingAPI(_ media: MediaType, _ timeWindow: TimeWindow)
    case upcomingAPI(_ media: MediaType)
    case popularAPI(_ media: MediaType)
}

extension EndpointStorage {
    var endpoint: Endpoint {
        switch self {
        case .trendingAPI(let media, let timeWindow):
            return Endpoint(url: "\(Constants.baseURL)\(Constants.trendingPath)\(media.path)\(timeWindow.path)", method: .get, queryParameters: TrendingQuery())
        case .upcomingAPI(let media):
            return Endpoint(url: "\(Constants.baseURL)\(media.path)\(Constants.upcomingPath)", method: .get)
        case .popularAPI(let media):
            return Endpoint(url: "\(Constants.baseURL)\(media.path)\(Constants.popularPath)", method: .get)
        }
    }
}
