//
//  MoviesListDTO.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

struct MoviesListDTO: Decodable {
    let page: Int?
    let movies: [MovieCardDTO]?
    let totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
    }
}

extension MoviesListDTO {
    func toDomain() -> MoviesList {
        return MoviesList(
            page: self.page ?? 0,
            movies: self.movies?.map { $0.toDomain() } ?? [],
            totalPages: self.totalPages ?? 0)
    }
}
