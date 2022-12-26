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
    case cast
    case crew
    case production
    case recommendations
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
    
    private let viewModel: MovieDetailViewModel
    private let movieDetailView = MovieDetailView()
    private weak var coordinator: MovieDetailFlowDependencies?
    private let imageRepository: ImageRepository?
    private let disposeBag = DisposeBag()
    
    init(_ coordinator: MovieDetailFlowDependencies, _ viewModel: MovieDetailViewModel, _ imageRepository: ImageRepository) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.imageRepository = imageRepository
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
        configureDataSource()
        viewModel.viewDidLoad()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.coordinator?.dismissMoviesDetailViewController()
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
        
        viewModel.backdropImage.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.setBackdropContent(data: data)
            })
            .disposed(by: disposeBag)
        
        movieDetailView.recommendationView.collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] content in
                self?.viewModel.itemSelected(content.item)
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedMovieId.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] id in
                self?.presentMovieDetailView(id)
            })
            .disposed(by: disposeBag)
        
        bindErrorAlert()
    }
    
    private func bindErrorAlert() {
        viewModel.errorOccured
            .subscribe(onNext: { [weak self] error in
                self?.showAlert(message: error.errorDescription!)
            })
            .disposed(by: disposeBag)
    }
    
    private func setViewContent(with movieDetail: MovieDetail) {
        movieDetailView.setContent(movieDetail)
        configureProductionSnapshot(movieDetail.productionCompanies)
        if let credits = movieDetail.credits {
            configureCastSnapshot(credits.cast)
            configureCrewSnapshot(credits.crew)
        }
        
        if let recommendations = movieDetail.recommendations {
            configureRecommendationSnapshot(recommendations.movies)
        }
    }
    
    private func setBackdropContent(data: Data?) {
        movieDetailView.updateBackdropImage(with: data)
    }
    
    private func presentMovieDetailView(_ id: Int?) {
        guard let id = id else {
            return
        }
        
        coordinator?.presentMovieDetailViewController(id)
    }
}

// MARK: - DataSource and Snapshot Method
extension MovieDetailViewController {
    private func configureDataSource() {
        configureProductionDataSource()
        configureCastDataSource()
        configureCrewDataSource()
        configureRecommendationDataSource()
    }
    
    // MARK: - Configuring DataSource
    private func configureCastDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CastCollectionViewCell, Cast> { [weak self] (cell, indexPath, cast) in
            cell.fill(with: cast, profileImageRepository: self?.imageRepository)
        }
        castDataSource = CastDataSource(collectionView: movieDetailView.castView.collectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, cast: Cast) -> UICollectionViewCell? in
            return self?.movieDetailView.castView.collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: cast)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: TitleSupplementaryView.titleElementKind) { (supplementaryView, string, indexPath) in
            supplementaryView.setTitleLabel("Cast", .preferredFont(forTextStyle: .headline))
        }
        
        castDataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.movieDetailView.castView.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
    }
    
    private func configureCrewDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CrewCollectionViewCell, Crew> { (cell, indexPath, crew) in
            cell.fill(with: crew)
        }
        crewDataSource = CrewDataSource(collectionView: movieDetailView.crewView.collectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, crew: Crew) -> UICollectionViewCell? in
            return self?.movieDetailView.crewView.collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: crew)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: TitleSupplementaryView.titleElementKind) { (supplementaryView, string, indexPath) in
            supplementaryView.setTitleLabel("Crew", .preferredFont(forTextStyle: .headline))
        }
        
        crewDataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.movieDetailView.crewView.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
    }
    
    private func configureProductionDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductionCompanyCollectionViewCell, ProductionCompany> { [weak self] (cell, indexPath, company) in
            cell.fill(with: company)
        }
        productionDataSource = ProductionDataSource(collectionView: movieDetailView.productionView.collectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, company: ProductionCompany) -> UICollectionViewCell? in
            return self?.movieDetailView.productionView.collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: company)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: TitleSupplementaryView.titleElementKind) { (supplementaryView, string, indexPath) in
            supplementaryView.setTitleLabel("Production", .preferredFont(forTextStyle: .headline))
        }
        
        productionDataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.movieDetailView.productionView.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
    }
    
    private func configureRecommendationDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<RecommendationCollectionCell, MoviePage> { [weak self] (cell, indexPath, movie) in
            cell.fill(with: movie, backdropImageRepository: self?.imageRepository)
        }
        
        recommendationDataSource = RecommendationDataSource(collectionView: movieDetailView.recommendationView.collectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, movie: MoviePage) -> UICollectionViewCell? in
            return self?.movieDetailView.recommendationView.collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: TitleSupplementaryView.titleElementKind) { (supplementaryView, string, indexPath) in
            supplementaryView.setTitleLabel("Recommendations", .preferredFont(forTextStyle: .headline))
        }
        
        recommendationDataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.movieDetailView.recommendationView.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
    }
    
    // MARK: - Configuring Snapshot
    private func configureCastSnapshot(_ cast: [Cast]) {
        castSnapshot = CastSnapshot()
        castSnapshot.appendSections([.cast])
        castSnapshot.appendItems(cast)
        castDataSource.apply(castSnapshot, animatingDifferences: true)
    }
    
    private func configureCrewSnapshot(_ crew: [Crew]) {
        crewSnapshot = CrewSnapshot()
        crewSnapshot.appendSections([.crew])
        crewSnapshot.appendItems(crew)
        crewDataSource.apply(crewSnapshot, animatingDifferences: true)
    }
    
    private func configureProductionSnapshot(_ productions: [ProductionCompany]) {
        productionSnapshot = ProductionSnapshot()
        productionSnapshot.appendSections([.production])
        productionSnapshot.appendItems(productions)
        productionDataSource.apply(productionSnapshot, animatingDifferences: true)
    }
    
    private func configureRecommendationSnapshot(_ recommendations: [MoviePage]) {
        recommendationSnapshot = RecommendationSnapshot()
        recommendationSnapshot.appendSections([.recommendations])
        recommendationSnapshot.appendItems(recommendations)
        recommendationDataSource.apply(recommendationSnapshot, animatingDifferences: true)
    }
}
