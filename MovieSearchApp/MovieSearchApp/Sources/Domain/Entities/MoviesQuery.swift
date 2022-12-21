//
//  MoviesQuery.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/16.
//

import Foundation

struct MoviesQuery: Encodable {
    let apiKey: String = Constants.apiKey
    let language: String = "en-US"
    let region: String = "US"
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case language, region
    }
}
