//
//  MoviesListDTO.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

struct MoviesListDTO: Decodable {
    let page: Int?
    let movies: [MovieCard]?
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
    }
}
