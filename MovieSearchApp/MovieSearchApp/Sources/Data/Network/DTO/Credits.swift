//
//  Credits.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/21.
//

import Foundation

struct Credits: Decodable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
}
