//
//  Endpoint.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/16.
//

import Foundation

struct Endpoint {
    let url: String
    let method: HttpMethod
    let requestBody: Encodable?
    let queryParameters: Encodable?
    
    init(url: String, method: HttpMethod, requestBody: Encodable? = nil, queryParameters: Encodable? = nil) {
        self.url = url
        self.method = method
        self.requestBody = requestBody
        self.queryParameters = queryParameters
    }
}
