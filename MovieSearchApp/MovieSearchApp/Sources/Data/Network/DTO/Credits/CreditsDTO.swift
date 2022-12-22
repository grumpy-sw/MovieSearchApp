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
