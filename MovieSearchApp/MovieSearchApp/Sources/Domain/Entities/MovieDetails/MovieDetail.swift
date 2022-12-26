//
//  MovieDetail.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

struct MovieDetail {
    let backdropPath: String
    let budget: Int
    let genres: [Genre]
    let id: Int
    let originalLanguage: String
    let overview: String
    let posterPath: String
    let productionCompanies: [ProductionCompany]
    let releaseDate: String
    let revenue: Int
    let runtime: Int
    let status: String
    let tagline: String
    let title: String
    let voteAverage: Double
    let recommendations: MovieCollection?
    let credits: Credits?
}
