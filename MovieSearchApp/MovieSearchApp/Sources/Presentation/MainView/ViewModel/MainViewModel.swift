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
    let mainViewUseCase: MainViewUseCase
    
    init(_ mainViewUseCase: MainViewUseCase) {
        self.mainViewUseCase = mainViewUseCase
    }
    
    func loadPopular() {
        
        mainViewUseCase.executeFetchPopular(media: .movie) { result in
            switch result {
            case .success(let data):
                print("## \(data)")
            case .failure(let error):
                print(error.errorDescription)
            }
        }
        
    }
}
