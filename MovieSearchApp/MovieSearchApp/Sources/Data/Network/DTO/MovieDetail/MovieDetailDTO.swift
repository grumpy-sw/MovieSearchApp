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
    let originalLanguage, overview, posterPath: String?
    let productionCompanies: [ProductionCompanyDTO]?
    let releaseDate: String?
    let revenue, runtime: Int?
    let status, tagline, title: String?
    let voteAverage: Double?
    let recommendations: MovieCollectionDTO?
    let credits: CreditsDTO?
    
}
