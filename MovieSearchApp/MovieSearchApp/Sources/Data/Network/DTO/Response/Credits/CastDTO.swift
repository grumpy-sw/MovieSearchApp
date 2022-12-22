//
//  Cast.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/21.
//

import Foundation

struct CastDTO: Decodable {
    let name: String?
    let profilePath: String?
    let character: String?

    enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
        case character
    }
}

extension CastDTO {
    func toDomain() -> Cast {
        return .init(
            name: self.name ?? "",
            profilePath: self.profilePath ?? "",
            character: self.character ?? ""
        )
    }
}
