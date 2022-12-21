//
//  MovieDetailViewModel.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/21.
//

import Foundation

protocol MovieDetailViewModelInput { }

protocol MovieDetailViewModelOutput { }

protocol MovieDetailViewModelable: MovieDetailViewModelInput, MovieDetailViewModelOutput { }

final class MovieDetailViewModel: MovieDetailViewModelable {
    private let movieDetailUseCase: MovieDetailUseCase
    private let movieId: Int
    
    init(_ movieId: Int, _ movieDetailUseCase: MovieDetailUseCase) {
        self.movieId = movieId
        self.movieDetailUseCase = movieDetailUseCase
    }
}
