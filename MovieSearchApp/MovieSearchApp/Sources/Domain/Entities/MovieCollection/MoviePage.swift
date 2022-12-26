//
//  MoviePage.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

struct MoviePage: Hashable {
    let identifier = UUID()
    
    let id: Int
    let title: String
    let posterPath: String
    let backdropPath: String
    let voteAverage: Double
    let genreIds: [Int]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
