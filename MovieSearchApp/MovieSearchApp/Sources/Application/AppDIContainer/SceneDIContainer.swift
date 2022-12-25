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
    
    func makeMovieDetailUseCase() -> MovieDetailUseCase {
        return DefaultMovieDetailUseCase(makeMovieDetailRepository())
    }
    
    // MARK: - Repositories
    func makeMainViewRepository() -> MainViewRepository {
        return DefaultMainViewRepository(dependencies)
    }
    
    func makeMoviesRepository() -> MoviesRepository {
        return DefaultMoviesRepository(dependencies)
    }
    
    func makeMovieDetailRepository() -> MovieDetailRepository {
        return DefaultMovieDetailRepository(dependencies)
    }
    
    func makeImageRepository() -> ImageRepository {
        return DefaultImageRepository(dependencies)
    }
    
    // MARK: - MainView(Movie Collections)
    func makeMainViewController(_ coordinator: MainViewFlowDependencies) -> MainViewController {
        return MainViewController(coordinator, makeMainViewModel(), makeImageRepository())
    }
    
    func makeMainViewModel() -> MainViewModel {
        return MainViewModel(makeMainViewUseCase())
    }
    
    // MARK: - Movies List
    func makeMoviesListViewController(_ coordinator: MoviesListFlowDependencies, _ query: String) -> MoviesListViewController {
        return MoviesListViewController(coordinator, makeMoviesListViewModel(), query)
    }
    
    func makeMoviesListViewModel() -> MoviesListViewModel {
        return MoviesListViewModel(makeSearchMoviesUseCase())
    }
    
    // MARK: - Movie Detail
    func makeMovieDetailViewController(_ coordinator: MovieDetailFlowDependencies, _ movieId: Int) -> MovieDetailViewController {
        return MovieDetailViewController(coordinator, makeMovieDetailViewModel(movieId))
    }
    
    func makeMovieDetailViewModel(_ movieId: Int) -> MovieDetailViewModel {
        return MovieDetailViewModel(movieId, makeMovieDetailUseCase())
    }
    
    
    // MARK: - Coordinator
    func makeAppCoordinator(_ navigationController: UINavigationController) -> FlowCoordinator {
        return FlowCoordinator(navigationController, self)
    }
    
}

extension SceneDIContainer: FlowCoordinatorDependencies {}
