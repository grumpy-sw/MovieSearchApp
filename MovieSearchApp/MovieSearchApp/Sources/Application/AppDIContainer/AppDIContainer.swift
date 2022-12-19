//
//  AppDIContainer.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import Foundation

final class AppDIContainer {
    
    // MARK: - Network
    var apiProvider: APIProvider = APIProvider(session: .shared)
    var imageProvoder: APIProvider = APIProvider(session: .shared)
    
    
}
