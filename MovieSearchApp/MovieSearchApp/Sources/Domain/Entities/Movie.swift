//
//  Movie.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/17.
//

import Foundation

struct Movie: Item, Decodable, Hashable {
    let identifier = UUID()
    
    var id: Int?
    var popularity: Double?
    let adult: Bool?
    let overview: String?
    let title: String?
    let video: Bool?
    
    let posterPath: String?
    let releaseDate: String?
    let genreIds: [Int]?
    let originalTitle: String?
    let originalLanguage: String?
    let backdropPath: String?
    let mediaType: String?
    let voteCount: Int?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case backdropPath = "backdrop_path"
        case mediaType = "media_type"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        
        case id, popularity, adult, overview, title, video
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func generateSampleData() -> Movie {
        return Movie(
            id: 315162,
            adult: false,
            overview: "아홉 개의 목숨 중 단 하나의 목숨만 남은 장화신은 고양이.  마지막 남은 목숨을 지키기 위해 히어로의 삶 대신 반려묘의 삶을 선택한 그에게 찾아온 마지막 기회, 바로 소원을 들어주는 소원별이 있는 곳을 알려주는 지도!  잃어버린 목숨을 되찾고 다시 히어로가 되기를 꿈꾸는 장화신은 고양이는 뜻밖에 동료가 된 앙숙 파트너 '키티 말랑손', 그저 친구들과 함께라면 모든 게 행복한 강아지 '페로'와 함께 소원별을 찾기 위해 길을 떠난다.  그리고 소원별을 노리는 또 다른 빌런들과 마주치게 되는데…",
            title: "장화신은 고양이: 끝내주는 모험",
            video: false,
            posterPath: "/58R71DxuezJ2qNg845FDxdPHoia.jpg",
            releaseDate: "2023-01-04",
            genreIds: [
                16, 12, 35, 10751, 14
            ],
            originalTitle: "Puss in Boots: The Last Wish",
            originalLanguage: "en",
            backdropPath: "/vNuHqmOJRQXY0PBd887DklSDlBP.jpg",
            mediaType: "movie",
            voteCount: 57,
            voteAverage: 8.1)
    }
}
