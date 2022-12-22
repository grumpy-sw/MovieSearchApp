//
//  MovieDetailViewController.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/21.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

protocol MovieDetailFlowDependencies: AnyObject {
    func presentMovieDetailViewController(_ id: Int)
    func dismissMoviesDetailViewController()
}

final class MovieDetailViewController: UIViewController {
    
    let viewModel: MovieDetailViewModel
    let movieDetailView = MovieDetailView()
    let coordinator: MovieDetailFlowDependencies
    private let disposeBag = DisposeBag()
    
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
        viewModel.viewDidLoad()
        bind()
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

extension MovieDetailViewController {
    func bind() {
        viewModel.title
            .asObservable()
            .map { $0 }
            .bind(to: movieDetailView.infoView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.overview
            .asObservable()
            .map { $0 }
            .bind(to: movieDetailView.descriptionView.overviewLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
