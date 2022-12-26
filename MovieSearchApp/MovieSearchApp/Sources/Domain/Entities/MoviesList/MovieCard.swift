//
//  MovieCard.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

struct MovieCard: Hashable {
    let identifier = UUID()
    
    let id: Int
    let title: String
    let posterPath: String
    let releaseDate: String
    let overview: String
    let voteAverage: Double
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
