//
//  MoviesRepository.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/20.
//

import Foundation

protocol MoviesRepository {
    @discardableResult
    func fetchMoviesList(query: MovieQuery, page: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
}
