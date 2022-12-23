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
    case recommendations
    case cast
    case crew
    case production
}

final class MovieDetailViewController: UIViewController {
    
    // MARK: - Typealias for DataSource and Snapshot
    fileprivate typealias CastDataSource = UICollectionViewDiffableDataSource<Section, Cast>
    fileprivate typealias CastSnapshot = NSDiffableDataSourceSnapshot<Section, Cast>
    fileprivate typealias CrewDataSource = UICollectionViewDiffableDataSource<Section, Crew>
    fileprivate typealias CrewSnapshot = NSDiffableDataSourceSnapshot<Section, Crew>
    fileprivate typealias ProductionDataSource = UICollectionViewDiffableDataSource<Section, ProductionCompany>
    fileprivate typealias ProductionSnapshot = NSDiffableDataSourceSnapshot<Section, ProductionCompany>
    fileprivate typealias RecommendationDataSource = UICollectionViewDiffableDataSource<Section, MoviePage>
    fileprivate typealias RecommendationSnapshot = NSDiffableDataSourceSnapshot<Section, MoviePage>
    

    private var castDataSource: CastDataSource! = nil
    private var castSnapshot: CastSnapshot! = nil
    
    private var crewDataSource: CrewDataSource! = nil
    private var crewSnapshot: CrewSnapshot! = nil
    
    private var productionDataSource: ProductionDataSource! = nil
    private var productionSnapshot: ProductionSnapshot! = nil
    
    private var recommendationDataSource: RecommendationDataSource! = nil
    private var recommendationSnapshot: RecommendationSnapshot! = nil
    
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        viewModel.viewDidLoad()
        bind()
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
        //movieDetailView.setContent(movieDetail)
//        if let recommendations = movieDetail.recommendations {
//            configureDataSource(recommendations)
//        }
        if let credits = movieDetail.credits {
            configureCastDataSource(credits)
        }
    }
    
    private func configureCastDataSource(_ credits: Credits) {
        
        let cellRegistration = UICollectionView.CellRegistration<CastCollectionViewCell, Cast> { (cell, indexPath, cast) in
            cell.updateImage(cast.profilePath)
            cell.nameLabel.text = cast.name
            cell.characterLabel.text = cast.character
        }
        
        castDataSource = UICollectionViewDiffableDataSource<Section, Cast>(collectionView: movieDetailView.crewView.collectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, cast: Cast) -> UICollectionViewCell? in
            return self?.movieDetailView.crewView.collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: cast)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<RecommendationSupplementaryView>(elementKind: RecommendationSupplementaryView.recommendationElementKind) { (supplementaryView, string, indexPath) in
            
        }
        
        castDataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.movieDetailView.crewView.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
        
        castSnapshot = NSDiffableDataSourceSnapshot<Section, Cast>()
        castSnapshot.appendSections([.crew])
        castSnapshot.appendItems(credits.cast)
        castDataSource.apply(castSnapshot, animatingDifferences: true)
    }
    
    private func configureDataSource(_ movieCollection: MovieCollection) {
        
        let cellRegistration = UICollectionView.CellRegistration<RecommendationCollectionCell, MoviePage> { (cell, indexPath, movie) in
            cell.updateImage(movie.backdropPath)
            cell.titleLabel.text = movie.title
            var genres: [GenreCategory] = []
            
            movie.genreIds.forEach {
                genres.append(GenreCategory(rawValue: $0)!)
            }
            cell.genreLabel.text = genres.map{ $0.desciption }.joined(separator: ",")
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, MoviePage>(collectionView: movieDetailView.recommendationView.collectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, movie: MoviePage) -> UICollectionViewCell? in
            return self?.movieDetailView.recommendationView.collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<RecommendationSupplementaryView>(elementKind: RecommendationSupplementaryView.recommendationElementKind) { (supplementaryView, string, indexPath) in
            
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.movieDetailView.recommendationView.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
        
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, MoviePage>()
        currentSnapshot.appendSections([.recommendations])
        currentSnapshot.appendItems(movieCollection.movies)
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
}



