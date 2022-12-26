//
//  MoviesListViewController.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/20.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

enum MoviesListFetching {
    case firstPage
    case nextPage
}

private enum Section: Hashable {
    case main
}

protocol MoviesListFlowDependencies: AnyObject {
    func presentMovieDetailViewController(_ id: Int)
    func dismissMoviesListViewController(_ viewController: MoviesListViewController)
}

final class MoviesListViewController: UIViewController, Alertable {
    
    fileprivate typealias DataSource = UICollectionViewDiffableDataSource<Section, MovieCard>
    fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MovieCard>
    
    private lazy var searchIconButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
    private lazy var cancelSearchButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
    private let viewModel: MoviesListViewModel
    
    private weak var coordinator: MoviesListFlowDependencies?
    private let moviesListView = MoviesListView()
    private var dataSource: DataSource! = nil
    private var currentSnapshot = Snapshot()
    private var query: String
    private let disposeBag = DisposeBag()
    private var fetching: MoviesListFetching = .firstPage
    private var currentPage: Int = 0
    private let posterImageRepository: ImageRepository?
    
    private lazy var searchBar = UISearchBar().then {
        $0.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0)
        $0.placeholder = "Search"
        $0.isTranslucent = false
        $0.backgroundImage = UIImage()
    }
    
    init(_ coordinator: MoviesListFlowDependencies, _ viewModel: MoviesListViewModel, _ query: String, _ posterImageRepository: ImageRepository) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.query = query
        self.posterImageRepository = posterImageRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = moviesListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        searchBar.text = query
        
        configureDataSource()
        viewModel.viewDidLoad()
        viewModel.searchButtonClicked(by: query)
        bind()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.coordinator?.dismissMoviesListViewController(self)
    }
}

extension MoviesListViewController {
    private func configureDataSource() {

        // MARK: - Cell Registration
        let cellRegistration = UICollectionView.CellRegistration<MoviesListItemCell, MovieCard> { [weak self] (cell, indexPath, movie) in
            cell.fill(with: movie, posterImageRepository: self?.posterImageRepository)
        }

        dataSource = DataSource(collectionView: moviesListView.collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: MovieCard) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
}

extension MoviesListViewController {
    private func bind() {
        searchBar.rx.searchButtonClicked
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { [weak self] _,_  in
                self?.searchBar.endEditing(true)
                self?.viewModel.searchButtonClicked(by: self?.searchBar.text ?? "")
            }
            .disposed(by: disposeBag)
        
        viewModel.queriedMovies
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                self?.configureSnapshot(with: movies)
            })
            .disposed(by: disposeBag)
        
        moviesListView.collectionView.rx.willDisplayCell
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { [weak self] _, cell in
                self?.viewModel.willDisplayCell(at: cell.at.item)
            }
            .disposed(by: disposeBag)
        
        viewModel.currentPageCount.asObservable()
            .subscribe(onNext: { [weak self] count in
                self?.currentPage = count
            })
            .disposed(by: disposeBag)
        
        viewModel.moviesListFetching.asObservable()
            .subscribe(onNext: { [weak self] result in
                self?.fetching = result
            })
            .disposed(by: disposeBag)
        
        moviesListView.collectionView.rx.itemSelected
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { [weak self] _, content in
                self?.moviesListView.collectionView.deselectItem(at: content, animated: true)
                self?.viewModel.itemSelected(content.item)
            }
            .disposed(by: disposeBag)
        
        viewModel.selectedMovieId.asObservable()
            .subscribe(onNext: { [weak self] id in
                self?.presentMovieDetailView(id)
            })
            .disposed(by: disposeBag)
        
        bindErrorAlert()
    }
    
    private func configureSnapshot(with movies: [MovieCard]) {
        guard !movies.isEmpty else {
            configureInitialSnapshot(with: [])
            return
        }
        
        switch fetching {
        case .firstPage:
            configureInitialSnapshot(with: movies)
        case .nextPage:
            appendSnapshot(with: movies)
        }
    }
    
    private func configureInitialSnapshot(with movies: [MovieCard]) {
        currentSnapshot = Snapshot()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(movies)
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    
    private func appendSnapshot(with movies: [MovieCard]) {
        let appendItems = Array(movies[((currentPage - 1) * 20)..<movies.count])
        currentSnapshot.appendItems(appendItems, toSection: .main)
        
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    
    private func presentMovieDetailView(_ id: Int?) {
        guard let id = id else {
            return
        }
        coordinator?.presentMovieDetailViewController(id)
    }
    
    private func bindErrorAlert() {
        viewModel.errorOccured
            .subscribe(onNext: { [weak self] error in
                self?.showAlert(message: error.errorDescription!)
            })
            .disposed(by: disposeBag)
    }
}
