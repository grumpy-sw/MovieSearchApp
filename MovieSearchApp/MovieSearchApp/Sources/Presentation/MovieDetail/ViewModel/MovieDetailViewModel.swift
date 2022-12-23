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
    var outputMovie: PublishRelay<MovieDetail> { get }
    var posterImage: PublishRelay<Data?> { get }
    var backdropImage: PublishRelay<Data?> { get }
}

protocol MovieDetailViewModelable: MovieDetailViewModelInput, MovieDetailViewModelOutput { }

final class MovieDetailViewModel: MovieDetailViewModelable {
    
    enum ImageKind {
        case poster
        case backdrop
    }
    
    private let movieDetailUseCase: MovieDetailUseCase
    private let movieId: Int
    private let decoder = JSONDecoder()
    
    var outputMovie: PublishRelay<MovieDetail> = .init()
    var posterImage: PublishRelay<Data?> = .init()
    var backdropImage: PublishRelay<Data?> = .init()
    
    private var posterImagePath: String = "" {
        didSet {
            updatePosterImage(width: 500)
        }
    }
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
    
    }
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
    
    private func updatePosterImage(width: Int) {
        fetchImageData(width: width, path: posterImagePath, kind: .poster)
    }
    
    private func updateBackdropImage(width: Int) {
        fetchImageData(width: width, path: backdropImagePath, kind: .backdrop)
    }
    
    private func fetchImageData(width: Int, path: String?, kind: ImageKind) {
        guard let path = path else {
            return
        }
        
        if path.isEmpty {
            return
        }
        
        _ = movieDetailUseCase.execute(width: width, path: path) { [weak self] result in
            switch result {
            case .success(let data):
                if kind == .poster {
                    self?.posterImage.accept(data)
                } else {
                    self?.backdropImage.accept(data)
                }
            case .failure(let error):
                print(path)
                print(error.errorDescription)
            }
        }
    }
    
    private func setObservableValues(_ movieDetails: MovieDetail) {
        outputMovie.accept(movieDetails)
        posterImagePath = movieDetails.posterPath
        backdropImagePath = movieDetails.backdropPath
    }
}
