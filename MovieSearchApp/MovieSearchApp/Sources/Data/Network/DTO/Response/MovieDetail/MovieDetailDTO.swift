//
//  MovieDetailDTO.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

struct MovieDetailDTO: Decodable {
    let backdropPath: String?
    let budget: Int?
    let genres: [Genre]?
    let id: Int?
    let originalLanguage: String?
    let overview: String?
    let posterPath: String?
    let productionCompanies: [ProductionCompanyDTO]
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let status: String?
    let tagline: String?
    let title: String?
    let voteAverage: Double?
    let recommendations: MovieCollectionDTO?
    let credits: CreditsDTO?
    
    enum CodingKeys: String, CodingKey {
        case budget, genres, id, overview, revenue, runtime, status, tagline, title, recommendations, credits
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

extension MovieDetailDTO {
    func toDomain() -> MovieDetail {
        return MovieDetail(
            backdropPath: self.backdropPath ?? "",
            budget: self.budget ?? 0,
            genres: self.genres ?? [],
            id: self.id ?? 0,
            originalLanguage: self.originalLanguage ?? "",
            overview: self.overview ?? "",
            posterPath: self.posterPath ?? "",
            productionCompanies: self.productionCompanies.map { $0.toDomain() },
            releaseDate: self.releaseDate ?? "",
            revenue: self.revenue ?? 0,
            runtime: self.runtime ?? 0,
            status: self.status ?? "",
            tagline: self.tagline ?? "",
            title: self.title ?? "",
            voteAverage: self.voteAverage ?? 0.0,
            recommendations: self.recommendations?.toDomain(),
            credits: self.credits?.toDomain())
    }
}
