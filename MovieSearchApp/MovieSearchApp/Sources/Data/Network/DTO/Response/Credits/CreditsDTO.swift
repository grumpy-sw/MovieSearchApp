//
//  Credits.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/21.
//

import Foundation

struct CreditsDTO: Decodable {
    let cast: [CastDTO]
    let crew: [CrewDTO]
}

extension CreditsDTO {
    func toDomain() -> Credits {
        return Credits(
            cast: self.cast.map{ $0.toDomain() },
            crew: self.crew.map{ $0.toDomain() })
    }
}
