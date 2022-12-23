//
//  Contributor.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/23.
//

import Foundation

enum ContributionKind: Int {
    case production = 0
    case cast
    case crew
}

struct Contributor: Hashable {
    let identifier = UUID()
    let name: String
    let imagePath: String?
    let additionalInfo: String?
    let type: ContributionKind
}
