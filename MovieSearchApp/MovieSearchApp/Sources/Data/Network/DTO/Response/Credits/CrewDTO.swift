//
//  Crew.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/21.
//

import Foundation

struct CrewDTO: Decodable {
    let name: String?
    let job: String?
}

extension CrewDTO {
    func toDomain() -> Crew {
        return .init(
            name: self.name ?? "",
            job: self.job ?? ""
        )
    }
}
