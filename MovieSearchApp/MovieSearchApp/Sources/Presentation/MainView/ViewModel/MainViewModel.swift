//
//  MainViewModel.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import Foundation
import RxSwift
import RxRelay

protocol MainViewModelInput {
    func viewDidLoad()
    func searchButtonClicked(_ query: String?)
    func itemSelected(_ index: Int, in section: CollectionKind)
}
protocol MainViewModelOutput {
    var popularMovies: BehaviorRelay<[MoviePage]> { get }
    var trendingMovies: BehaviorRelay<[MoviePage]> { get }
    var upcomingMovies: BehaviorRelay<[MoviePage]> { get }
    var favoriteMovies: BehaviorRelay<[MoviePage]> { get }
    var errorOccured: PublishRelay<NetworkError> { get }
    var selectedMovieId: BehaviorRelay<Int?> { get }
    var search: PublishRelay<String> { get }
}

protocol MainViewModelable: MainViewModelInput, MainViewModelOutput {}

final class MainViewModel: MainViewModelable {
    
    var popularMovies: BehaviorRelay<[MoviePage]> = .init(value: [])
    var trendingMovies: BehaviorRelay<[MoviePage]> = .init(value: [])
    var upcomingMovies: BehaviorRelay<[MoviePage]> = .init(value: [])
    var favoriteMovies: BehaviorRelay<[MoviePage]> = .init(value: [])
    var errorOccured: PublishRelay<NetworkError> = .init()
    var selectedMovieId: BehaviorRelay<Int?> = .init(value: nil)
    var search: PublishRelay<String> = .init()
    
    let mainViewUseCase: MainViewUseCase
    
    init(_ mainViewUseCase: MainViewUseCase) {
        self.mainViewUseCase = mainViewUseCase
    }
    
    func viewDidLoad() {
        fetchPopularMoviesList()
        fetchTrendingMoviesList()
        fetchUpcomingMoviesList()
    }
    
    func searchButtonClicked(_ query: String?) {
        if let query = query {
            search.accept(query)
        }
    }
    
    func itemSelected(_ index: Int, in section: CollectionKind) {
        selectedMovieId.accept(matchedMovieItemId(section, index))
    }
}

extension MainViewModel {
    
    private func fetchPopularMoviesList() {
        _ = mainViewUseCase.executeFetchPopular(media: .movie) { [weak self] result in
            switch result {
            case .success(let response):
                self?.popularMovies.accept(response.movies)
            case .failure(let error):
                self?.errorOccured.accept(error)
            }
        }
    }
    
    private func fetchTrendingMoviesList() {
        _ = mainViewUseCase.executeFetchTrending(media: .movie, timeWindow: .day) { [weak self] result in
            switch result {
            case .success(let data):
                self?.trendingMovies.accept(data.movies)
            case .failure(let error):
                self?.errorOccured.accept(error)
            }
        }
    }
    
    private func fetchUpcomingMoviesList() {
        _ = mainViewUseCase.executeFetchUpcoming(media: .movie) { [weak self] result in
            switch result {
            case .success(let data):
                self?.upcomingMovies.accept(data.movies)
            case .failure(let error):
                self?.errorOccured.accept(error)
            }
        }
    }
    
    private func matchedMovieItemId(_ section: CollectionKind, _ index: Int) -> Int {
        var id: Int? = nil
        switch section {
        case .popular:
            id = popularMovies.value[index].id
        case .trending:
            id = trendingMovies.value[index].id
        case .upcoming:
            id = upcomingMovies.value[index].id
        case .favorite:
            id = favoriteMovies.value[index].id
        }
        
        guard let id = id else {
            return -1
        }
        return id
    }
}
