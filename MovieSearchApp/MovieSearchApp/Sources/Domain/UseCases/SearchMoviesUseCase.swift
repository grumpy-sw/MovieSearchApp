//
//  SearchMoviesUseCase.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/20.
//

import Foundation

protocol SearchMoviesUseCase {
    func execute(requestQuery: SearchMoviesUseCaseRequestQuery, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
}

final class DefaultSearchMoviesUseCase: SearchMoviesUseCase {
    
    private let moviesRepository: MoviesRepository
    
    init(_ moviesRepository: MoviesRepository) {
        self.moviesRepository = moviesRepository
    }
    
    func execute(requestQuery: SearchMoviesUseCaseRequestQuery, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        return moviesRepository.fetchMoviesList(query: requestQuery.query, page: requestQuery.page) { result in
            completion(result)
        }
    }
}

struct SearchMoviesUseCaseRequestQuery {
    let query: MovieQuery
    let page: Int
}
