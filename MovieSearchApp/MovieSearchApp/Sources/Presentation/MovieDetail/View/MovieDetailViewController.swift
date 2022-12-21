//
//  MovieDetailViewController.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/21.
//

import UIKit

protocol MovieDetailFlowDependencies: AnyObject {
    func presentMovieDetailViewController(_ id: Int)
    func dismissMoviesDetailViewController()
}

final class MovieDetailViewController: UIViewController {
    
    let viewModel: MovieDetailViewModel
    let movieDetailView = MovieDetailView()
    let coordinator: MovieDetailFlowDependencies
    
    init(_ coordinator: MovieDetailFlowDependencies, _ viewModel: MovieDetailViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        self.view = movieDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemOrange
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.coordinator.dismissMoviesDetailViewController()
    }
}
