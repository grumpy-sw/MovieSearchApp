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
    var imageProvider: APIProvider = APIProvider(session: .shared)
    
    let decoder: JSONDecoder = JSONDecoder()
    
    func makeSceneDIContainer() -> SceneDIContainer {
        let dependencies = SceneDIContainer.Dependencies(apiProvider: apiProvider, imageProvider: imageProvider, decoder: decoder)
        return SceneDIContainer(dependencies: dependencies)
    }
}
