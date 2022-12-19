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

class MainViewController: UIViewController {

    struct MovieCollection: Hashable {
        let title: String
        let movies: [Movie]
        
        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    private let mainView = MainView()
    let viewModel: MainViewModel
    let disposeBag = DisposeBag()
    var dataSource: UICollectionViewDiffableDataSource<MovieCollection, Movie>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<MovieCollection, Movie>! = nil
    
    init(viewModel: MainViewModel) {
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
        navigationItem.rightBarButtonItem = .init(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: nil)
        
        bind()
        
        viewModel.viewDidLoad()
        
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
        
//        currentSnapshot = NSDiffableDataSourceSnapshot<MovieCollection, Movie>()
//        collections.forEach {
//            let collection = $0
//            currentSnapshot.appendSections([collection])
//            currentSnapshot.appendItems(collection.movies)
//        }
//        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
}

extension MainViewController {
    private func bind() {
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
}
