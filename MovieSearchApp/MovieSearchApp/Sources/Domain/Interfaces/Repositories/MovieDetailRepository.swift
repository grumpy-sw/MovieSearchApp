//
//  MovieDetailRepository.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import Foundation

protocol MovieDetailRepository {
    @discardableResult
    func fetchMovieDetails(id: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
}
