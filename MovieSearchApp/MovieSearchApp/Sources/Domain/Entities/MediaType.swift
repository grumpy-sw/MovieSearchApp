//
//  MediaType.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/16.
//

import Foundation

enum MediaType: String {
    case all
    case movie
    case tv
    case person
    
    var path: String {
        switch self {
        case .all:
            return "/all"
        case .movie:
            return "/movie"
        case .tv:
            return "/tv"
        case .person:
            return "/person"
        }
    }
}
