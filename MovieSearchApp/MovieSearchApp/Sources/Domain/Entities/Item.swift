//
//  Item.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/16.
//

import Foundation

protocol Item: Decodable {
    var id: Int? { get }
    var popularity: Double? { get }
}
