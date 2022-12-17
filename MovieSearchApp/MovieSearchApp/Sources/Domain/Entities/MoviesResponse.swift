//
//  MoviesResponse.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/16.
//

import Foundation

struct MoviesResponse: Decodable {
    let page: Int
    let movies: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case movies = "results"
        case page
    }
}
