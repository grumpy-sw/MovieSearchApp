//
//  ViewController.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/15.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

protocol MainViewFlowDependencies: AnyObject {
    func presentMoviesListViewController(_ query: String)
    func presentMovieDetailViewController(_ id: Int)
}

enum CollectionKind: Int {
    case popular = 0
    case trending
    case upcoming
    
    var title: String {
        switch self {
        case .popular:
            return "What's Popular"
        case .trending:
            return "Trending"
        case .upcoming:
            return "Upcoming"
        }
    }
}

class MainViewController: UIViewController {
    
    private let mainView = MainView()
    private lazy var searchBar = UISearchBar().then {
        $0.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.size.width * 0.8, height: 0)
        $0.placeholder = "Search"
        $0.isTranslucent = false
        $0.backgroundImage = UIImage()
    }
    
    private lazy var searchIconButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(showSearchBar))
    
    private lazy var cancelSearchButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(hideSearchBar))
    
    private weak var coordinator: MainViewFlowDependencies?
    private let viewModel: MainViewModel
    private let posterImageRepository: ImageRepository?
    
    let disposeBag = DisposeBag()
    var dataSource: UICollectionViewDiffableDataSource<CollectionKind, MoviePage>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<CollectionKind, MoviePage>! = nil
    
    init(_ coordinator: MainViewFlowDependencies, _ viewModel: MainViewModel, _ posterImageRepository: ImageRepository) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.posterImageRepository = posterImageRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        configureDataSource()
        
        title = "MovieSearchApp"
        navigationItem.rightBarButtonItem = searchIconButton
        
        viewModel.viewDidLoad()
        bind()
    }
    
    @objc func showSearchBar() {
        title = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = cancelSearchButton
    }
    
    @objc func hideSearchBar() {
        searchBar.text = nil
        self.navigationItem.leftBarButtonItem = nil
        title = "MovieSearchApp"
        self.navigationItem.rightBarButtonItem = searchIconButton
    }
}

extension MainViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MovieCollectionCell, MoviePage> { [weak self] (cell, indexPath, movie) in
            cell.fill(with: movie, posterImageRepository: self?.posterImageRepository)
        }
        
        dataSource = UICollectionViewDiffableDataSource<CollectionKind, MoviePage>(collectionView: mainView.collectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, movie: MoviePage) -> UICollectionViewCell? in
            return self?.mainView.collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: TitleSupplementaryView.titleElementKind) { (supplementaryView, string, indexPath) in
            if let kind = CollectionKind(rawValue: indexPath.section) {
                supplementaryView.setTitleLabel(kind.title)
            }
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.mainView.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
        configureInitialSnapshot()
    }
    
    private func configureInitialSnapshot() {
        currentSnapshot = NSDiffableDataSourceSnapshot<CollectionKind, MoviePage>()
        currentSnapshot.appendSections([.popular])
        currentSnapshot.appendSections([.trending])
        currentSnapshot.appendSections([.upcoming])
    }
}

extension MainViewController {
    private func bind() {
        searchBar.rx.searchButtonClicked
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { [weak self] _,_  in
                self?.viewModel.searchButtonClicked(self?.searchBar.text)
            }
            .disposed(by: disposeBag)
        
        viewModel.search
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                self?.presentMoviesListView(query)
            })
            .disposed(by: disposeBag)
        
        viewModel.popularMovies
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                self?.configureSnapshot(with: movies, in: .popular)
            })
            .disposed(by: disposeBag)
        
        viewModel.trendingMovies
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                self?.configureSnapshot(with: movies, in: .trending)
            })
            .disposed(by: disposeBag)
        
        viewModel.upcomingMovies
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                self?.configureSnapshot(with: movies, in: .upcoming)
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] content in
                if let section = CollectionKind(rawValue: content.section) {
                    self?.viewModel.itemSelected(content.item, in: section)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedMovieId
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] id in
                self?.presentMovieDetailView(id)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureSnapshot(with movies: [MoviePage], in section: CollectionKind) {
        guard !movies.isEmpty else {
            return
        }
        appendSnapshot(with: movies, in: section)
    }
    
    private func configureInitialSnapshot(with movies: [MoviePage], in section: CollectionKind) {
        currentSnapshot = NSDiffableDataSourceSnapshot<CollectionKind, MoviePage>()
        currentSnapshot.appendSections([section])
        currentSnapshot.appendItems(movies)
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    
    private func appendSnapshot(with movies: [MoviePage], in section: CollectionKind) {
        currentSnapshot.appendItems(movies, toSection: section)
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    
    private func presentMoviesListView(_ query: String) {
        searchBar.endEditing(true)
        hideSearchBar()
        coordinator?.presentMoviesListViewController(query)
    }
    
    private func presentMovieDetailView(_ id: Int?) {
        guard let id = id else {
            return
        }
        coordinator?.presentMovieDetailViewController(id)
    }
}
