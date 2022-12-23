//
//  Crew.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

struct Crew: Hashable {
    let name: String
    let job: String
    
    let identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension Crew {
    func toContributor() -> Contributor {
        return Contributor(name: name, imagePath: nil, additionalInfo: job, type: .crew)
    }
}
