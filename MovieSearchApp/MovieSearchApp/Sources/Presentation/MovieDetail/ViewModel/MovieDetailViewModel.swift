//
//  MovieDetailViewModel.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/21.
//

import Foundation
import RxSwift
import RxRelay

protocol MovieDetailViewModelInput {
    func viewDidLoad()
    func itemSelected(_ index: Int)
}

protocol MovieDetailViewModelOutput {
    var title: PublishRelay<String> { get }
    var overview: PublishRelay<String> { get }
    var recommandations: BehaviorRelay<[MoviePage]> { get }
    var productions: BehaviorRelay<[ProductionCompany]> { get }
}

protocol MovieDetailViewModelable: MovieDetailViewModelInput, MovieDetailViewModelOutput { }

final class MovieDetailViewModel: MovieDetailViewModelable {
    
    private let movieDetailUseCase: MovieDetailUseCase
    private let movieId: Int
    private let decoder = JSONDecoder()

    var title: PublishRelay<String> = .init()
    var overview: PublishRelay<String> = .init()
    var recommandations: BehaviorRelay<[MoviePage]> = .init(value: [])
    var productions: BehaviorRelay<[ProductionCompany]> = .init(value: [])
    
    init(_ movieId: Int, _ movieDetailUseCase: MovieDetailUseCase) {
        self.movieId = movieId
        self.movieDetailUseCase = movieDetailUseCase
    }
    
    func viewDidLoad() {
        fetchMovieDetails(by: movieId)
    }
    func itemSelected(_ index: Int) { }
}

extension MovieDetailViewModel {
    private func fetchMovieDetails(by movieId: Int) {
        _ = movieDetailUseCase.execute(id: movieId) { [weak self] result in
            switch result {
            case .success(let data):
                if let response = try? self?.decoder.decode(MovieDetailDTO.self, from: data) {
                    self?.setObservableValues(response.toDomain())
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    private func setObservableValues(_ movieDetails: MovieDetail) {
        title.accept(movieDetails.title)
        overview.accept(movieDetails.overview)
    }
}
