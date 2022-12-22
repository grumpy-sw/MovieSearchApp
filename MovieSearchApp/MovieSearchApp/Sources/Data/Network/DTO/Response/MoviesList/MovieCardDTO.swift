//
//  MovieCardDTO.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

struct MovieCardDTO: Decodable {
    let id: Int?
    let title: String?
    let posterPath: String?
    let releaseDate: String?
    let overview: String?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

extension MovieCardDTO {
    func toDomain() -> MovieCard {
        return MovieCard(
            id: self.id ?? 0,
            title: self.title ?? "",
            posterPath: self.posterPath ?? "",
            releaseDate: self.releaseDate ?? "",
            overview: self.overview ?? "",
            voteAverage: self.voteAverage ?? 0.0)
    }
}
