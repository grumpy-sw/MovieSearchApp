//
//  MovieQuery.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/18.
//

import Foundation

struct MovieQuery: Encodable {
    let page: Int
    let query: String
    
    let apiKey: String = Constants.apiKey
    let language: String = "en-US"
    let region: String = "US"
    
    
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case page, query, language, region
    }
}
