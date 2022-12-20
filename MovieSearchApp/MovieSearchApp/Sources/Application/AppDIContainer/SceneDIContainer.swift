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
    func makeMainViewUseCase() -> MainViewUseCase {
        return DefaultMainViewUseCase(mainViewRepository: makeMainViewRepository())
    }
    
    func makeSearchMoviesUseCase() -> SearchMoviesUseCase {
        return DefaultSearchMoviesUseCase(makeMoviesRepository())
    }
    
    // MARK: - Repositories
    func makeMainViewRepository() -> MainViewRepository {
        return DefaultMainViewRepository(dependencies)
    }
    
    func makeMoviesRepository() -> MoviesRepository {
        return DefaultMoviesRepository(dependencies)
    }
    
    // MARK: - MainView(Movie Collections)
    func makeMainViewController() -> MainViewController {
        return MainViewController(viewModel: makeMainViewModel())
    }
    
    func makeMainViewModel() -> MainViewModel {
        return MainViewModel(makeMainViewUseCase())
    }
    
    // MARK: - Movies List
    func makeMoviesListViewController() -> MoviesListViewController {
        return MoviesListViewController(viewModel: makeMoviesListViewModel())
    }
    
    func makeMoviesListViewModel() -> MoviesListViewModel {
        return MoviesListViewModel()
    }
    
    
    // MARK: - Movie Detail
    
    // MARK: - Coordinator
    func makeAppCoordinator(navigationController: UINavigationController) -> FlowCoordinator {
        return FlowCoordinator(navigationController, self)
    }
    
}

extension SceneDIContainer: FlowCoordinatorDependencies {}
