//
//  AppCoordinator.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import UIKit

protocol FlowCoordinatorDependencies {
    func makeMainViewController(_ coordinator: MainViewFlowDependencies) -> MainViewController
    func makeMoviesListViewController(_ coordinator: MoviesListFlowDependencies, _ query: String) -> MoviesListViewController
    func makeMovieDetailViewController(_ coordinator: MovieDetailFlowDependencies, _ movieId: Int) -> MovieDetailViewController
}

final class FlowCoordinator {
    private weak var navigationController: UINavigationController?
    private weak var mainViewController: MainViewController?
    private weak var moviesListViewController: MoviesListViewController?
    private var movieDetailViewControllers: [MovieDetailViewController] = []
    private let dependencies: FlowCoordinatorDependencies
    
    init(_ navigationController: UINavigationController, _ dependencies: FlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    deinit {
        print("# deinit")
    }
}

extension FlowCoordinator {
    func start() {
        let vc = dependencies.makeMainViewController(self)
        self.mainViewController = vc
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

extension FlowCoordinator: MainViewFlowDependencies, MoviesListFlowDependencies, MovieDetailFlowDependencies {
    
    func presentMoviesListViewController(_ query: String) {
        let vc = dependencies.makeMoviesListViewController(self, query)
        self.moviesListViewController = vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentMovieDetailViewController(_ id: Int) {
        let vc = dependencies.makeMovieDetailViewController(self, id)
        self.movieDetailViewControllers.append(vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func dismissMoviesListViewController(_ viewController: MoviesListViewController) {
        self.moviesListViewController = nil
    }
    
    func dismissMoviesDetailViewController() {
        guard movieDetailViewControllers.isEmpty else {
            self.movieDetailViewControllers.removeLast()
            return
        }
    }
}

