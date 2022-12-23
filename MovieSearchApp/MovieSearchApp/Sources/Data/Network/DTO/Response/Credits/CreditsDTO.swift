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
            crew: slice(recombine(filterCrew())).map { $0.toDomain() })
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
    
    func recombine(_ crew: [CrewDTO]) -> [CrewDTO] {
        var dictionary = [String:[String]]()
        
        for member in crew {
            guard let name = member.name, let job = member.job else {
                continue
            }
            
            if let jobs = dictionary[name] {
                dictionary[name] = jobs + [job]
            } else {
                dictionary[name] = [job]
            }
        }

        return dictionary.map { CrewDTO(name: $0.key, job:$0.value.joined(separator: ",")) }
    }
}
