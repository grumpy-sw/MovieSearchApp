//
//  ImageRepository.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/26.
//

import Foundation

protocol ImageRepository {
    @discardableResult
    func fetchImage(with posterPath: String, width: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
}
