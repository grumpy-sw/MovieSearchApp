//
//  SceneDIContainer.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import UIKit

final class SceneDIContainer {
    
    struct Dependencies {
        let apiProvider: APIProvider
        let imageProvider: APIProvider
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Persistent Storage (For Search History)
    
    // MARK: - Use Cases
    
    // MARK: - Repositories
    
    // MARK: - MainView(Movie Collections)
    
    // MARK: - Movies List
    
    // MARK: - Movie Detail
}
