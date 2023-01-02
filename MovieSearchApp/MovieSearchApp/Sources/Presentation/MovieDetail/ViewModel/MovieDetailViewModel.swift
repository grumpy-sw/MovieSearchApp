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
    func scrolled(to offset: CGFloat)
}

protocol MovieDetailViewModelOutput {
    var outputMovie: PublishRelay<MovieDetail> { get }
    var backdropImage: PublishRelay<Data?> { get }
    var selectedMovieId: PublishRelay<Int> { get }
    var errorOccured: PublishRelay<NetworkError> { get }
    var isTransparentTopBar: BehaviorRelay<Bool> { get }
}

protocol MovieDetailViewModelable: MovieDetailViewModelInput, MovieDetailViewModelOutput { }

final class MovieDetailViewModel: MovieDetailViewModelable {
    private let movieDetailUseCase: MovieDetailUseCase
    private let movieId: Int
    
    var outputMovie: PublishRelay<MovieDetail> = .init()
    var backdropImage: PublishRelay<Data?> = .init()
    var selectedMovieId: PublishRelay<Int> = .init()
    var errorOccured: PublishRelay<NetworkError> = .init()
    var isTransparentTopBar: BehaviorRelay<Bool> = .init(value: true)
    
    private var recommendations: [Int] = []
    
    private var backdropImagePath: String = "" {
        didSet {
            updateBackdropImage(width: 780)
        }
    }
    
    init(_ movieId: Int, _ movieDetailUseCase: MovieDetailUseCase) {
        self.movieId = movieId
        self.movieDetailUseCase = movieDetailUseCase
    }
    
    func viewDidLoad() {
        fetchMovieDetails(by: movieId)
    }
    
    func itemSelected(_ index: Int) {
        self.selectedMovieId.accept(recommendations[index])
    }
    
    func scrolled(to offset: CGFloat) {
        self.isTransparentTopBar.accept(
            offset > 300 ? false : true
        )
    }
}

extension MovieDetailViewModel {
    private func fetchMovieDetails(by movieId: Int) {
        _ = movieDetailUseCase.execute(id: movieId) { [weak self] result in
            switch result {
            case .success(let response):
                self?.setObservableValues(response)
            case .failure(let error):
                self?.errorOccured.accept(error)
            }
        }
    }
    
    private func updateBackdropImage(width: Int) {
        fetchImageData(width: width, path: backdropImagePath)
    }
    
    private func fetchImageData(width: Int, path: String?) {
        guard let path = path else {
            return
        }
        
        if path.isEmpty {
            return
        }
        
        _ = movieDetailUseCase.execute(width: width, path: path) { [weak self] result in
            switch result {
            case .success(let data):
                self?.backdropImage.accept(data)
            case .failure(let error):
                self?.errorOccured.accept(error)
            }
        }
    }
    
    private func setObservableValues(_ response: MovieDetail) {
        outputMovie.accept(response)
        backdropImagePath = response.backdropPath
        guard let recommendations = response.recommendations else {
            return
        }
        self.recommendations = recommendations.movies.map { $0.id }
    }
}
