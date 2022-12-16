//
//  TrendingQuery.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/16.
//

import Foundation

struct TrendingQuery: Encodable {
    let apiKey: String
    let language: String = "ko-KR"
    let region: String = "KR"
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case language, region
    }
}
