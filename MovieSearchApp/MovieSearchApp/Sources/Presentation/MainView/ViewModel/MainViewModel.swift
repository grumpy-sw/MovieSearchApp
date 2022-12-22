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
    func itemSelected(_ index: Int, in section: SectionCategory)
}
protocol MainViewModelOutput {
    var popularMovies: BehaviorRelay<[MoviePage]> { get }
    var trendingMovies: BehaviorRelay<[MoviePage]> { get }
    var upcomingMovies: BehaviorRelay<[MoviePage]> { get }
    var errorOcurred: Observable<NetworkError> { get }
    var selectedMovieId: BehaviorRelay<Int?> { get }
    var search: PublishRelay<String> { get }
}

protocol MainViewModelable: MainViewModelInput, MainViewModelOutput {}

final class MainViewModel: MainViewModelable {
    
    var popularMovies: BehaviorRelay<[MoviePage]> = .init(value: [])
    var trendingMovies: BehaviorRelay<[MoviePage]> = .init(value: [])
    var upcomingMovies: BehaviorRelay<[MoviePage]> = .init(value: [])
    var errorOcurred: Observable<NetworkError> = .empty()
    var selectedMovieId: BehaviorRelay<Int?> = .init(value: nil)
    var search: PublishRelay<String> = .init()
    
    let mainViewUseCase: MainViewUseCase
    let decoder = JSONDecoder()
    
    init(_ mainViewUseCase: MainViewUseCase) {
        self.mainViewUseCase = mainViewUseCase
    }
    
    func viewDidLoad() {
        DispatchQueue.global().sync {
            fetchPopularMoviesList()
            
        }
        DispatchQueue.global().sync {
            fetchTrendingMoviesList()
            
        }
        DispatchQueue.global().sync {
            fetchUpcomingMoviesList()
        }
    }
    
    func searchButtonClicked(_ query: String?) {
        if let query = query {
            search.accept(query)
        }
    }
    
    func itemSelected(_ index: Int, in section: SectionCategory) {
        selectedMovieId.accept(matchedMovieItemId(section, index))
    }
}

extension MainViewModel {
    
    private func fetchPopularMoviesList() {
        _ = mainViewUseCase.executeFetchPopular(media: .movie) { [weak self] result in
            switch result {
            case .success(let data):
                if let response = try? self?.decoder.decode(MovieCollectionDTO.self, from: data) {
                    self?.popularMovies.accept(response.toDomain().movies)
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    private func fetchTrendingMoviesList() {
        _ = mainViewUseCase.executeFetchTrending(media: .movie, timeWindow: .day) { [weak self] result in
            switch result {
            case .success(let data):
                if let response = try? self?.decoder.decode(MovieCollectionDTO.self, from: data) {
                    self?.trendingMovies.accept(response.toDomain().movies)
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    private func fetchUpcomingMoviesList() {
        _ = mainViewUseCase.executeFetchUpcoming(media: .movie) { [weak self] result in
            switch result {
            case .success(let data):
                if let response = try? self?.decoder.decode(MovieCollectionDTO.self, from: data) {
                    self?.upcomingMovies.accept(response.toDomain().movies)
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    private func matchedMovieItemId(_ section: SectionCategory, _ index: Int) -> Int {
        var id: Int? = nil
        switch section {
        case .popular:
            id = popularMovies.value[index].id
        case .trending:
            id = trendingMovies.value[index].id
        case .upcoming:
            id = upcomingMovies.value[index].id
        }
        
        guard let id = id else {
            return -1
        }
        return id
    }
}
