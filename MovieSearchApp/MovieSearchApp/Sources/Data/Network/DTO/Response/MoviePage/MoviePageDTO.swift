//
//  MoviePageDTO.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

struct MoviePageDTO: Decodable {
    let id: Int?
    let title: String?
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double?
    let genreIds: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case genreIds = "genre_ids"
    }
}

extension MoviePageDTO {
    func toDomain() -> MoviePage {
        return .init(
            id: self.id ?? 0,
            title: self.title ?? "",
            posterPath: self.posterPath ?? "",
            backdropPath: self.backdropPath ?? "",
            voteAverage: self.voteAverage ?? 0.0,
            genreIds: self.genreIds ?? []
        )
    }
}
