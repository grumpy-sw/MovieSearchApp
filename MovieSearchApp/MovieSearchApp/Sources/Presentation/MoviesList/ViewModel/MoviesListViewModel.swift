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
    func willDisplayCell(at index: Int)
}
protocol MoviesListViewModelOutput {
    var queriedMovies: BehaviorRelay<[Movie]> { get }
    var errorOcurred: Observable<NetworkError> { get }
    var currentPageCount: BehaviorRelay<Int> { get }
    var moviesListFetching: BehaviorRelay<MoviesListFetching> { get }
    
    var isEmpty: Bool { get }
}

protocol MoviesListViewModelable: MoviesListViewModelInput, MoviesListViewModelOutput {}

final class MoviesListViewModel: MoviesListViewModelable {
    
    private let searchMoviesUseCase: SearchMoviesUseCase
    var query: String = ""
    
    var queriedMovies: BehaviorRelay<[Movie]> = .init(value: [])
    var isEmpty: Bool { return queriedMovies.value.isEmpty }
    var errorOcurred: Observable<NetworkError> = .empty()
    var currentPageCount: BehaviorRelay<Int> = .init(value: 1)
    var moviesListFetching: BehaviorRelay<MoviesListFetching> = .init(value: .firstPage)
    
    var currentPage: Int = 1
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    var isLoading: Bool = false
    let decoder = JSONDecoder()
    
    init(_ searchMoviesUseCase: SearchMoviesUseCase) {
        self.searchMoviesUseCase = searchMoviesUseCase
    }
    
    func viewDidLoad() {}
    
    func searchButtonClicked(by query: String) {
        currentPage = 1
        queriedMovies.accept([])
        moviesListFetching.accept(.firstPage)
        fetchMoviesList(by: query)
    }
    func willDisplayCell(at index: Int) {
        guard hasMorePages else {
            return
        }
        
        if index > queriedMovies.value.count - 4, !isLoading {
            currentPage += 1
            moviesListFetching.accept(.nextPage)
            fetchMoviesList(by: query)
        }
    }
    
    func fetchMoviesList(by query: String) {
        self.query = query
        isLoading = true
        searchMoviesUseCase.execute(requestQuery: query, page: currentPage) { [weak self] result in
            switch result {
            case .success(let data):
                if let response = try? self?.decoder.decode(MoviesResponse.self, from: data) {
                    self?.appendPage(response)
                }
            case .failure(let error):
                print(error.errorDescription)
            }
            self?.isLoading = false
        }
    }
    
    func appendPage(_ response: MoviesResponse) {
        currentPage = response.page
        totalPageCount = response.totalPages
        currentPageCount.accept(currentPage)
        queriedMovies.accept(queriedMovies.value + response.movies)
    }
}
