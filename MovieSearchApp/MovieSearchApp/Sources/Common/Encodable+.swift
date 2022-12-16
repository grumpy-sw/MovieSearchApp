//
//  Encodable+.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/16.
//

import Foundation

extension Encodable {
    func toDictionary() -> Result<[String: Any], NetworkError> {
        do {
            let data = try JSONEncoder().encode(self)
            guard let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                return .failure(.decodeError)
            }
            return .success(jsonData)
        } catch {
            return .failure(.encodeError)
        }
    }
}
