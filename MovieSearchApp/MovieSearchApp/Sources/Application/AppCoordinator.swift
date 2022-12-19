//
//  AppCoordinator.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import UIKit

final class AppCoordinator {
    
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let sceneDIContainer = appDIContainer.makeSceneDIContainer()
        let flow = sceneDIContainer.makeAppCoordinator(navigationController: navigationController)
        flow.start()
    }
}
