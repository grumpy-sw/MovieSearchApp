//
//  MoviesListQueryDTO.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

struct MoviesListQueryDTO: Encodable {
    let apiKey: String = Constants.apiKey
    let query: String
    let page: Int
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case query, page
    }
}
