//
//  MovieCollectionDTO.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

struct MovieCollectionDTO: Decodable {
    let movies: [MoviePageDTO]?
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}
