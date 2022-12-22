//
//  MovieDetailQueryDTO.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

struct MovieDetailQueryDTO: Encodable {
    let apiKey: String = Constants.apiKey
    let appendToResponse = Constants.appendToResponse.joined(separator: ",")
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case appendToResponse = "append_to_response"
    }
}
