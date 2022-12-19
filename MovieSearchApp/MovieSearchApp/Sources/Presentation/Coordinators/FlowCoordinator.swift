//
//  AppCoordinator.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import UIKit

protocol FlowCoordinatorDependencies {
    func makeMainViewController() -> MainViewController
}

final class FlowCoordinator {
    private weak var navigationController: UINavigationController?
    private weak var mainViewController: MainViewController?
    private let dependencies: FlowCoordinatorDependencies
    
    init(_ navigationController: UINavigationController, _ dependencies: FlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
}

extension FlowCoordinator {
    func start() {
        let vc = dependencies.makeMainViewController()
        navigationController?.pushViewController(vc, animated: false)
        self.mainViewController = vc
    }
}
