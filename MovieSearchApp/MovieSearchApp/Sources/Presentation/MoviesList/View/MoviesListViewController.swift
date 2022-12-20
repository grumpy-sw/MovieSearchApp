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

final class MoviesListViewController: UIViewController {
    
    private weak var coordinator: MoviesListFlowDependencies?
    let viewModel: MoviesListViewModel
    private let moviesListView = MoviesListView()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>! = nil
    private var query: String
    private let disposeBag = DisposeBag()
    private var currentSnapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
    
    private var fetching: MoviesListFetching = .firstPage
    private var currentPage: Int = 0
    
    private lazy var searchBar = UISearchBar().then {
        $0.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0)
        $0.placeholder = "검색"
        $0.isTranslucent = false
        $0.backgroundImage = UIImage()
    }
    
    private lazy var searchIconButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
    
    private lazy var cancelSearchButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: nil)
    
    
    init(_ coordinator: MoviesListFlowDependencies, _ viewModel: MoviesListViewModel, _ query: String) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.query = query
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
        let cellRegistration = UICollectionView.CellRegistration<MoviesListItemCell, Movie> { (cell, indexPath, movie) in
            cell.updateCell(with: movie)
            cell.accessories = [.disclosureIndicator()]
        }

        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: moviesListView.collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Movie) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
}

extension MoviesListViewController {
    func bind() {
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
        
        moviesListView.collectionView.rx.didEndDecelerating
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { [weak self] _, _ in
                self?.viewModel.didEndDecelerating()
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
    }
    
    private func configureSnapshot(with movies: [Movie]) {
        guard !movies.isEmpty else {
            return
        }
        print("## snapshot type \(fetching), current Page: \(currentPage)")
        
        switch fetching {
        case .firstPage:
            configureInitialSnapshot(with: movies)
        case .nextPage:
            appendSnapshot(with: movies)
        }
    }
    
    private func configureInitialSnapshot(with movies: [Movie]) {
        print(#function)
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(movies)
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    
    private func appendSnapshot(with movies: [Movie]) {
        print(#function)
        let appendItems = Array(movies[((currentPage - 1) * 20)..<movies.count])
        
        //currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(appendItems)
        
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
}
