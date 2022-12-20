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

class MainViewController: UIViewController {
    
    enum SectionCategory: Int {
        case popular = 0
        case trending
        case upcoming
    }
    
    struct MovieCollection: Hashable {
        let title: String
        let movies: [Movie]
        
        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    private let mainView = MainView()
    private lazy var searchBar = UISearchBar().then {
        $0.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.size.width * 0.8, height: 0)
        $0.placeholder = "검색"
        //$0.sizeToFit()
        //$0.searchTextField.backgroundColor = .clear
        $0.isTranslucent = false
        $0.backgroundImage = UIImage()
    }
    
    private lazy var searchIconButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(showSearchBar))
    
    private lazy var cancelSearchButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(hideSearchBar))
    
    private weak var coordinator: MainViewFlowDependencies?
    let viewModel: MainViewModel
    let disposeBag = DisposeBag()
    var dataSource: UICollectionViewDiffableDataSource<MovieCollection, Movie>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<MovieCollection, Movie>! = nil
    
    init(_ coordinator: MainViewFlowDependencies, _ viewModel: MainViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
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
        self.navigationItem.leftBarButtonItem = nil
        title = "MovieSearchApp"
        self.navigationItem.rightBarButtonItem = searchIconButton
    }
}

extension MainViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MovieCollectionCell, Movie> { (cell, indexPath, movie) in
            cell.updateImage(movie.posterPath ?? "")
            cell.titleLabel.text = movie.title
            
            var genres: [GenreCategory] = []
            
            movie.genreIds?.forEach {
                genres.append(GenreCategory(rawValue: $0)!)
            }
            cell.genreLabel.text = genres.map{ $0.desciption }.joined(separator: ",")
        }
        
        dataSource = UICollectionViewDiffableDataSource<MovieCollection, Movie>(collectionView: mainView.collectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, movie: Movie) -> UICollectionViewCell? in
            return self?.mainView.collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: TitleSupplementaryView.titleElementKind) { (supplementaryView, string, indexPath) in
            if let snapshot = self.currentSnapshot {
                let movieCategory = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.label.text = movieCategory.title
            }
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.mainView.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
    }
}

extension MainViewController {
    private func bind() {
        
        searchBar.rx.searchButtonClicked
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { [weak self] _,_  in
                self?.coordinator?.presentMoviesListViewController(self?.searchBar.text ?? "")
                self?.searchBar.endEditing(true)
                self?.hideSearchBar()
                
            }
            .disposed(by: disposeBag)
        
        viewModel.popularMovies
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                self?.configureSnapshot(with: movies, of: "What's Popular")
            })
            .disposed(by: disposeBag)
        viewModel.trendingMovies
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                self?.configureSnapshot(with: movies, of: "Today's Trend")
            })
            .disposed(by: disposeBag)
        viewModel.upcomingMovies
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                self?.configureSnapshot(with: movies, of: "Upcoming")
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] content in
                if let section = SectionCategory(rawValue: content.section) {
                    guard let list = self?.matchCollectionType(section) else { return }
                    print(list[content.item].title!)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configureSnapshot(with movies: [Movie], of title: String) {
        guard !movies.isEmpty else {
            return
        }
        if currentSnapshot == nil {
            configureInitialSnapshot(with: movies, of: title)
        } else {
            appendSnapshot(with: movies, of: title)
        }
    }
    
    private func configureInitialSnapshot(with movies: [Movie], of title: String) {
        currentSnapshot = NSDiffableDataSourceSnapshot<MovieCollection, Movie>()
        let collection = MovieCollection(title: title, movies: movies)
        currentSnapshot.appendSections([collection])
        currentSnapshot.appendItems(collection.movies)
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    
    private func appendSnapshot(with movies: [Movie], of title: String) {
        
        let collection = MovieCollection(title: title, movies: movies)
        currentSnapshot.appendSections([collection])
        currentSnapshot.appendItems(collection.movies)
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    
    private func matchCollectionType(_ section: SectionCategory) -> [Movie] {
        switch section {
        case .popular:
            return viewModel.popularMovies.value
        case .trending:
            return viewModel.trendingMovies.value
        case .upcoming:
            return viewModel.upcomingMovies.value
        }
    }
}
