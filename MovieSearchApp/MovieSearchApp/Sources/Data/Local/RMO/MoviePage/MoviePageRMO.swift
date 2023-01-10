//
//  MoviePageRMO.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2023/01/10.
//

import Foundation
import RealmSwift

class MoviePageRMO: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var posterPath: String
    @Persisted var backdropPath: String
    @Persisted var voteAverage: Double
    @Persisted var genreIdList: List<Int>
    var genreIdArray: [Int] {
        get {
            return genreIdList.map{ $0 }
        }
        set {
            genreIdList.removeAll()
            genreIdList.append(objectsIn: newValue)
        }
    }
    
    convenience init(id: Int, title: String, posterPath: String, voteAverage: Double, genreIds: [Int]) {
        self.init()
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.voteAverage = voteAverage
        self.genreIdArray = genreIds
    }

}

extension MoviePageRMO {
    func toDomain() -> MoviePage {
        return .init(
            id: self.id,
            title: self.title,
            posterPath: self.posterPath,
            backdropPath: "",
            voteAverage: self.voteAverage,
            genreIds: self.genreIdArray
        )
    }
}
