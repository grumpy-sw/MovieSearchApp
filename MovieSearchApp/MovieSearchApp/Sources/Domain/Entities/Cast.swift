//
//  Cast.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

struct Cast: Hashable {
    let name: String
    let profilePath: String
    let character: String
    
    let identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension Cast {
    func toContributor() -> Contributor {
        return Contributor(name: name, imagePath: profilePath, additionalInfo: character, type: .cast)
    }
}
