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
    func viewDidLoad()
    func searchButtonClicked(by query: String)
    func didEndDecelerating()
}
protocol MoviesListViewModelOutput {
    var queriedMovies: BehaviorRelay<[Movie]> { get }
    var errorOcurred: Observable<NetworkError> { get }
    var currentPageCount: Observable<Int> { get }
    var moviesListFetching: Observable<MoviesListFetching> { get }
    var isEmpty: Bool { get }
}

protocol MoviesListViewModelable: MoviesListViewModelInput, MoviesListViewModelOutput {}

final class MoviesListViewModel: MoviesListViewModelable {
    
    private let searchMoviesUseCase: SearchMoviesUseCase
    var query: String = ""
    
    var queriedMovies: BehaviorRelay<[Movie]> = .init(value: [])
    var isEmpty: Bool { return queriedMovies.value.isEmpty }
    var errorOcurred: Observable<NetworkError> = .empty()
    var currentPageCount: Observable<Int> = .of(1)
    var moviesListFetching: Observable<MoviesListFetching> = .of(.firstPage)
    
    var currentPage: Int = 1
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    let decoder = JSONDecoder()
    
    init(_ searchMoviesUseCase: SearchMoviesUseCase) {
        self.searchMoviesUseCase = searchMoviesUseCase
    }
    
    func viewDidLoad() {}
    
    func searchButtonClicked(by query: String) {
        queriedMovies = .init(value: [])
        moviesListFetching = Observable.of(.firstPage)
        fetchMoviesList(by: query)
    }
    
    func didEndDecelerating() {
        if hasMorePages {
            currentPage += 1
            moviesListFetching = Observable.of(.nextPage)
            fetchMoviesList(by: query)
        }
    }
    
    func fetchMoviesList(by query: String) {
        self.query = query
        searchMoviesUseCase.execute(requestQuery: query, page: currentPage) { [weak self] result in
            switch result {
            case .success(let data):
                if let response = try? self?.decoder.decode(MoviesResponse.self, from: data) {
                    self?.appendPage(response)
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    func appendPage(_ response: MoviesResponse) {
        currentPage = response.page
        totalPageCount = response.totalPages
        currentPageCount = Observable.of(response.page)
        queriedMovies.accept(queriedMovies.value + response.movies)
    }
}
