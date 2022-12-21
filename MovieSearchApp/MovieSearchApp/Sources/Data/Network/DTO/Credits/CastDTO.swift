//
//  Cast.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/21.
//

import Foundation

struct CastDTO: Decodable {
    let name: String
    let profilePath: String?
    let character: String

    enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
        case character
    }
}

