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
}
protocol MoviesListViewModelOutput {
}

protocol MoviesListViewModelable: MoviesListViewModelInput, MoviesListViewModelOutput {}

final class MoviesListViewModel: MoviesListViewModelable {
    
}
