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
}
protocol MainViewModelOutput {
    var popularMovies: BehaviorRelay<[Movie]> { get }
    var trendingMovies: BehaviorRelay<[Movie]> { get }
    var upcomingMovies: BehaviorRelay<[Movie]> { get }
    var errorOcurred: Observable<NetworkError> { get }
}

protocol MainViewModelable: MainViewModelInput, MainViewModelOutput {}

final class MainViewModel: MainViewModelable {
    var popularMovies: BehaviorRelay<[Movie]> = .init(value: [])
    var trendingMovies: BehaviorRelay<[Movie]> = .init(value: [])
    var upcomingMovies: BehaviorRelay<[Movie]> = .init(value: [])
    var errorOcurred: Observable<NetworkError> = .empty()
    
    let mainViewUseCase: MainViewUseCase
    let decoder = JSONDecoder()
    
    init(_ mainViewUseCase: MainViewUseCase) {
        self.mainViewUseCase = mainViewUseCase
    }
    
    func viewDidLoad() {
        fetchPopularMoviesList()
        fetchTrendingMoviesList()
        fetchUpcomingMoviesList()
    }
    
    func fetchPopularMoviesList() {
        mainViewUseCase.executeFetchPopular(media: .movie) { [weak self] result in
            switch result {
            case .success(let data):
                if let movies = try? self?.decoder.decode(MoviesResponse.self, from: data).movies {
                    self?.popularMovies.accept(movies)
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    func fetchTrendingMoviesList() {
        mainViewUseCase.executeFetchTrending(media: .movie, timeWindow: .day) { [weak self] result in
            switch result {
            case .success(let data):
                if let movies = try? self?.decoder.decode(MoviesResponse.self, from: data).movies {
                    self?.trendingMovies.accept(movies)
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    func fetchUpcomingMoviesList() {
        mainViewUseCase.executeFetchUpcoming(media: .movie) { [weak self] result in
            switch result {
            case .success(let data):
                if let movies = try? self?.decoder.decode(MoviesResponse.self, from: data).movies {
                    self?.upcomingMovies.accept(movies)
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
}
