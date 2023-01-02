//
//  SearchMoviesUseCase.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/20.
//

import Foundation

protocol SearchMoviesUseCase {
    func execute(requestQuery: String, page: Int, completion: @escaping (Result<MoviesList, NetworkError>) -> Void) -> URLSessionDataTask?
}

final class DefaultSearchMoviesUseCase: SearchMoviesUseCase {
    
    private let moviesRepository: MoviesRepository
    
    init(_ moviesRepository: MoviesRepository) {
        self.moviesRepository = moviesRepository
    }
    
    func execute(requestQuery: String, page: Int, completion: @escaping (Result<MoviesList, NetworkError>) -> Void) -> URLSessionDataTask? {
        return moviesRepository.fetchMoviesList(query: requestQuery, page: page) { result in
            switch result {
            case .success(let moviesListDTO):
                completion(.success(moviesListDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
