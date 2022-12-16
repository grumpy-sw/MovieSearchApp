//
//  Movie.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/17.
//

import Foundation

struct Movie: Item, Decodable {
    var id: Int?
    var popularity: Double?
    let adult: Bool?
    let overview: String?
    let title: String?
    let video: Bool?
    
    let posterPath: String?
    let releaseDate: String?
    let genreIds: [Int]?
    let originalTitle: String?
    let originalLanguage: String?
    let backdropPath: String?
    let mediaType: String?
    let voteCount: Int?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case backdropPath = "backdrop_path"
        case mediaType = "media_type"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        
        case id, popularity, adult, overview, title, video
    }
}
