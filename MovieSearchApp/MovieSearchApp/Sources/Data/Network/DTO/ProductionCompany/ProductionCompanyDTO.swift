//
//  ProductionCompanyDTO.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

struct ProductionCompanyDTO: Decodable {
    let name: String?
    let logoPath: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case logoPath = "logo_path"
    }
}

extension ProductionCompanyDTO {
    func toDomain() -> ProductionCompany {
        return ProductionCompany(name: self.name ?? "", logoPath: self.logoPath ?? "")
    }
}
