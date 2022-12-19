//
//  MainViewModel.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import Foundation

protocol MainViewModelInput {}
protocol MainViewModelOutput {}

protocol MainViewModelable: MainViewModelInput, MainViewModelOutput {}

final class MainViewModel {
    let apiProvider = APIProvider(session: .shared)
}