//
//  NetworkError.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/16.
//

import Foundation

enum NetworkError: LocalizedError {
    case unknownError
    case invalidHttpStatusCodeError(statusCode: Int)
    case urlComponentError
    case emptyDataError
    case decodeError
    case encodeError
    case responseError

    var errorDescription: String? {
        switch self {
        case .unknownError: return "Unknowned Error."
        case .invalidHttpStatusCodeError(let statusCode): return "Invalid Http Status Code, \(statusCode)."
        case .urlComponentError: return "URL components Error."
        case .emptyDataError: return "Data is Empty."
        case .decodeError: return "Decode Error."
        case .encodeError: return "Encode Error."
        case .responseError: return "Response Error."
        }
    }
}
