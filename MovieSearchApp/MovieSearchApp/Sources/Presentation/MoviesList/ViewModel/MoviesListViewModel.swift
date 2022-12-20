//
//  MoviesListViewModel.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/20.
//

import Foundation
import RxSwift
import RxRelay

protocol MoviesListViewModelInput {
    func viewDidLoad(with query: String)
    func didLoadNextPage()
}
protocol MoviesListViewModelOutput {
    var queriedMovies: BehaviorRelay<[Movie]> { get }
    var errorOcurred: Observable<NetworkError> { get }
    var isEmpty: Bool { get }
}

protocol MoviesListViewModelable: MoviesListViewModelInput, MoviesListViewModelOutput {}

final class MoviesListViewModel: MoviesListViewModelable {
    
    private let searchMoviesUseCase: SearchMoviesUseCase
    var query: Observable<String> = Observable.of("")
    
    var queriedMovies: BehaviorRelay<[Movie]> = .init(value: [])
    var isEmpty: Bool { return queriedMovies.value.isEmpty }
    var errorOcurred: Observable<NetworkError> = .empty()
    
    var currentPage: Int = 1
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    
    let decoder = JSONDecoder()
    
    init(_ searchMoviesUseCase: SearchMoviesUseCase) {
        self.searchMoviesUseCase = searchMoviesUseCase
    }
    
    func viewDidLoad(with query: String) {
        fetchMoviesList(by: query)
    }
    
    func didLoadNextPage() {
        
    }
    
    func fetchMoviesList(by query: String) {
        searchMoviesUseCase.execute(requestQuery: query, page: currentPage) { [weak self] result in
            switch result {
            case .success(let data):
                if let movies = try? self?.decoder.decode(MoviesResponse.self, from: data).movies {
                    self?.queriedMovies.accept(movies)
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
}
