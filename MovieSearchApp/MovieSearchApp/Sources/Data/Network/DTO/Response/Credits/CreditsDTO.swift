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

extension CreditsDTO {
    func toDomain() -> Credits {
        return Credits(
            cast: slice(cast).map { $0.toDomain() },
            crew: slice(filterCrew()).map { $0.toDomain() })
    }
    
    private func slice<T>(_ collection: [T]) -> [T] {
        if collection.count > 10 {
            return Array(collection[..<10])
        }
        return collection
    }
    
    private func filterCrew() -> [CrewDTO] {
        let showingJobs = ["Director", "Story", "Writer", "ScreenPlay", "Writer"]
        return crew.filter { showingJobs.contains($0.job ?? "") }
    }
}
