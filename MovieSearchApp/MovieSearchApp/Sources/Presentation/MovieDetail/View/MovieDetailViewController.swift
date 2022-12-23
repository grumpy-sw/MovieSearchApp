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
    

    private var contributorDataSource: UICollectionViewDiffableDataSource<ContributionKind, Contributor>! = nil
    private var contributorSnapshot: NSDiffableDataSourceSnapshot<ContributionKind, Contributor>! = nil
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
        configureDataSource()
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
        movieDetailView.setContent(movieDetail)
        configureProductionSnapshot(movieDetail.productionCompanies)
        configureContributorSnapshot(movieDetail.productionCompanies.map { $0.toContributor()})
        if let credits = movieDetail.credits {
            configureContributorSnapshot(credits.cast.map { $0.toContributor() })
            configureContributorSnapshot(credits.crew.map { $0.toContributor() })
        }
        if let recommendations = movieDetail.recommendations {
            configureRecommendationSnapshot(recommendations.movies)
        }
    }
}

// MARK: - DataSource and Snapshot Method
extension MovieDetailViewController {
    
    private func configureDataSource() {
        configureRecommendationDataSource()
        configureContributorDataSource()
    }
    
    // MARK: - Configuring DataSource
    private func configureContributorDataSource() {
        let productionRegistration = UICollectionView.CellRegistration<ProductionCompanyCollectionViewCell, Contributor> { (cell, indexPath, company) in
            cell.nameLabel.text = company.name
            guard let imagePath = company.imagePath else {
                return
            }
            cell.updateImage(imagePath)
        }
        
        let castRegistration = UICollectionView.CellRegistration<CastCollectionViewCell, Contributor> { (cell, indexPath, cast) in
            cell.nameLabel.text = cast.name
            cell.characterLabel.text = cast.additionalInfo
            guard let imagePath = cast.imagePath else {
                return
            }
            cell.updateImage(imagePath)
        }
        
        let crewRegistration = UICollectionView.CellRegistration<CrewCollectionViewCell, Contributor> { (cell, indexPath, crew) in
            cell.nameLabel.text = crew.name
            cell.jobLabel.text = crew.additionalInfo
        }
        
        contributorDataSource = UICollectionViewDiffableDataSource<ContributionKind, Contributor>(collectionView: movieDetailView.crewView.collectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, contributor: Contributor) -> UICollectionViewCell? in
            switch contributor.type {
            case .cast:
                return self?.movieDetailView.crewView.collectionView.dequeueConfiguredReusableCell(using: castRegistration, for: indexPath, item: contributor)
            case .production:
                return self?.movieDetailView.crewView.collectionView.dequeueConfiguredReusableCell(using: productionRegistration, for: indexPath, item: contributor)
            case .crew:
                return self?.movieDetailView.crewView.collectionView.dequeueConfiguredReusableCell(using: crewRegistration, for: indexPath, item: contributor)
            }
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: TitleSupplementaryView.titleElementKind) { (supplementaryView, string, indexPath) in
            guard let kind = ContributionKind(rawValue: indexPath.section) else {
                return
            }
            var title = "Untitled"
            switch kind {
            case .production:
                title = "Production"
            case .cast:
                title = "Cast"
            case .crew:
                title = "Crew"
            }
            supplementaryView.setTitleLabel(title)
        }
        
        contributorDataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.movieDetailView.crewView.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
        
        contributorSnapshot = NSDiffableDataSourceSnapshot<ContributionKind, Contributor>()
        contributorSnapshot.appendSections([.production])
        contributorSnapshot.appendSections([.cast])
        contributorSnapshot.appendSections([.crew])
    }
    
    private func configureContributorSnapshot(_ contributors: [Contributor]) {
        let kind = contributors.first?.type
        contributorSnapshot.appendItems(contributors, toSection: kind)
        contributorDataSource.apply(contributorSnapshot, animatingDifferences: true)
    }
    
    private func configureProductionDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductionCompanyCollectionViewCell, ProductionCompany> { (cell, indexPath, company) in
            cell.updateImage(company.logoPath)
            cell.nameLabel.text = company.name
        }
        
        productionDataSource = ProductionDataSource(collectionView: movieDetailView.crewView.productionCollectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, company: ProductionCompany) -> UICollectionViewCell? in
            return self?.movieDetailView.crewView.productionCollectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: company)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: TitleSupplementaryView.titleElementKind) { (supplementaryView, string, indexPath) in
            supplementaryView.setTitleLabel("Productions")
        }
        
        productionDataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.movieDetailView.crewView.productionCollectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
    }
    
    private func configureCastDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CastCollectionViewCell, Cast> { (cell, indexPath, cast) in
            cell.updateImage(cast.profilePath)
            cell.nameLabel.text = cast.name
            cell.characterLabel.text = cast.character
        }
        
        castDataSource = CastDataSource(collectionView: movieDetailView.crewView.castCollectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, cast: Cast) -> UICollectionViewCell? in
            return self?.movieDetailView.crewView.castCollectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: cast)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: TitleSupplementaryView.titleElementKind) { (supplementaryView, string, indexPath) in
            supplementaryView.setTitleLabel("Cast")
        }
        
        castDataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.movieDetailView.crewView.castCollectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
    }
    
    private func configureCrewDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CrewCollectionViewCell, Crew> { (cell, indexPath, crew) in
            cell.nameLabel.text = crew.name
            cell.jobLabel.text = crew.job
        }
        
        crewDataSource = CrewDataSource(collectionView: movieDetailView.crewView.crewCollectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, cast: Crew) -> UICollectionViewCell? in
            return self?.movieDetailView.crewView.crewCollectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: cast)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: TitleSupplementaryView.titleElementKind) { (supplementaryView, string, indexPath) in
            supplementaryView.setTitleLabel("Crew")
        }
        
        crewDataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.movieDetailView.crewView.crewCollectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
    }
    
    private func configureRecommendationDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<RecommendationCollectionCell, MoviePage> { (cell, indexPath, movie) in
            cell.updateImage(movie.backdropPath)
            cell.titleLabel.text = movie.title
        }
        
        recommendationDataSource = RecommendationDataSource(collectionView: movieDetailView.recommendationView.collectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, movie: MoviePage) -> UICollectionViewCell? in
            return self?.movieDetailView.recommendationView.collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: TitleSupplementaryView.titleElementKind) { (supplementaryView, string, indexPath) in
            supplementaryView.setTitleLabel("Recommendations")
        }
        
        recommendationDataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.movieDetailView.recommendationView.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
    }
    
    // MARK: - Configuring Snapshot
    private func configureProductionSnapshot(_ productionCompanies: [ProductionCompany]) {
        productionSnapshot = ProductionSnapshot()
        productionSnapshot.appendSections([.production])
        productionSnapshot.appendItems(productionCompanies)
        productionDataSource.apply(productionSnapshot, animatingDifferences: true)
    }
    
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
    
    private func configureRecommendationSnapshot(_ recommendations: [MoviePage]) {
        recommendationSnapshot = RecommendationSnapshot()
        recommendationSnapshot.appendSections([.recommendations])
        recommendationSnapshot.appendItems(recommendations)
        recommendationDataSource.apply(recommendationSnapshot, animatingDifferences: true)
    }
}


