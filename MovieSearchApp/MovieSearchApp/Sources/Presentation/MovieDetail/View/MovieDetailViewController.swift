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

private enum Section: Hashable {
    case main
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
        viewModel.outputMovie
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movieDetail in
                self?.setViewContent(with: movieDetail)
            })
            .disposed(by: disposeBag)
    }
    
    private func setViewContent(with movieDetail: MovieDetail) {
        movieDetailView.setContent(movieDetail)
        print(movieDetail.recommendations)
        if let recommendations = movieDetail.recommendations {
            configureDataSource(recommendations)
        }
    }
    
    private func configureDataSource(_ movieCollection: MovieCollection) {
        var dataSource: UICollectionViewDiffableDataSource<Section, MoviePage>! = nil
        var currentSnapshot: NSDiffableDataSourceSnapshot<Section, MoviePage>! = nil
        
        let cellRegistration = UICollectionView.CellRegistration<RecommendationCollectionCell, MoviePage> { (cell, indexPath, movie) in
            cell.updateImage(movie.posterPath)
            cell.titleLabel.text = movie.title
            
            var genres: [GenreCategory] = []
            
            movie.genreIds.forEach {
                genres.append(GenreCategory(rawValue: $0)!)
            }
            cell.genreLabel.text = genres.map{ $0.desciption }.joined(separator: ",")
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, MoviePage>(collectionView: movieDetailView.recommandationView.recommandationCollectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, movie: MoviePage) -> UICollectionViewCell? in
            return self?.movieDetailView.recommandationView.recommandationCollectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: TitleSupplementaryView.titleElementKind) { (supplementaryView, string, indexPath) in
            
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.movieDetailView.recommandationView.recommandationCollectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
        
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, MoviePage>()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(movieCollection.movies)
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
}



