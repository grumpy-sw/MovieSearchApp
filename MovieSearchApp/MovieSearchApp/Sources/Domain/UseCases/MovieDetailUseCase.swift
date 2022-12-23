//
//  MovieDetailUseCase.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

protocol MovieDetailUseCase {
    func execute(id: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
    func execute(width: Int, path: String, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
}

final class DefaultMovieDetailUseCase: MovieDetailUseCase {
    private let movieDetailRepository: MovieDetailRepository
    
    init(_ movieDetailRepository: MovieDetailRepository) {
        self.movieDetailRepository = movieDetailRepository
    }
    
    func execute(id: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        return movieDetailRepository.fetchMovieDetails(id: id) { result in
            completion(result)
        }
    }
    
    func execute(width: Int, path: String, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        return movieDetailRepository.fetchImageData(width: width, path: path) { result in
            completion(result)
        }
    }
}
