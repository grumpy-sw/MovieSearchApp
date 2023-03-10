//
//  MovieDetailUseCase.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

protocol MovieDetailUseCase {
    func execute(id: Int, completion: @escaping (Result<MovieDetail, NetworkError>) -> Void) -> URLSessionDataTask?
    func execute(width: Int, path: String, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
}

final class DefaultMovieDetailUseCase: MovieDetailUseCase {
    private let movieDetailRepository: MovieDetailRepository
    
    init(_ movieDetailRepository: MovieDetailRepository) {
        self.movieDetailRepository = movieDetailRepository
    }
    
    func execute(id: Int, completion: @escaping (Result<MovieDetail, NetworkError>) -> Void) -> URLSessionDataTask? {
        return movieDetailRepository.fetchMovieDetails(id: id) { result in
            switch result {
            case .success(let movieDetail):
                completion(.success(movieDetail))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func execute(width: Int, path: String, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        return movieDetailRepository.fetchImageData(width: width, path: path) { result in
            completion(result)
        }
    }
}
