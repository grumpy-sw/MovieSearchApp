//
//  MovieDetail.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import Foundation

struct MovieDetail: Decodable {
    let adult: Bool
    let budget: Int // 제작비
    let genres: [Genre]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    //let productionCompanies: [String]
    let releaseDate: String
    let revenue: Int    // 수익
    let runtime: Int
    let status: String
    let tagline: String
    let title: String
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case adult, budget, id, overview, genres, popularity, revenue, runtime, status, tagline, title
    }
}
