//
//  MovieCollectionQueryDTO.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

struct MovieCollectionQueryDTO: Encodable {
    let apiKey: String = Constants.apiKey
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}
