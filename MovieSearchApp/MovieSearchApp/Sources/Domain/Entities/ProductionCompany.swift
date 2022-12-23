//
//  ProductionCompany.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

struct ProductionCompany: Hashable {
    let name: String
    let logoPath: String
    
    let identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
