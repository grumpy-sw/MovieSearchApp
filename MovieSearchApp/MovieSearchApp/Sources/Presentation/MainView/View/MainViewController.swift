//
//  ViewController.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/15.
//

import UIKit

class MainViewController: UIViewController {

    struct MovieCollection: Hashable {
        let title: String
        let movies: [Movie]
        
        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    struct ThumbnailItem: Hashable {
        let url: String
        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    private let mainView = MainView()
    var dataSource: UICollectionViewDiffableDataSource<MovieCollection, Movie>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<MovieCollection, Movie>! = nil
    
    var collections: [MovieCollection] {
        return _collections
    }
    
    fileprivate var _collections = [MovieCollection]()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        generateCollections()
        configureDataSource()
        
        title = "MovieSearchApp"
        navigationItem.rightBarButtonItem = .init(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: nil)
    }
    
    
    let apiProvider = APIProvider(session: .shared)
    let decoder = JSONDecoder()
}

extension MainViewController {
    func generateCollections() {
        _collections = [
            MovieCollection(title: "What's Popular", movies: []),
            MovieCollection(title: "Trending", movies: []),
            MovieCollection(title: "Upcoming", movies: [])
        ]
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MovieCollectionCell, Movie> { (cell, indexPath, movie) in
            cell.titleLabel.text = movie.title
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
        
        currentSnapshot = NSDiffableDataSourceSnapshot<MovieCollection, Movie>()
        collections.forEach {
            let collection = $0
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.movies)
        }
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
}

extension MainViewController {
    private func testCall1() async -> [Movie] {
        let popular = EndpointStorage.popularAPI(.movie).endpoint
        
        var movies: [Movie] = []
        
        
        await apiProvider.request(endpoint: popular) { [weak self] result in
            switch result {
            case .success(let data):
                let popularItems = try! self?.decoder.decode(MoviesResponse.self, from: data)
                movies = popularItems!.movies
            case .failure(let error):
                print(error.errorDescription)
                
            }
        }
        return movies
    }
    
    private func testCall2() {
        let trending = EndpointStorage.trendingAPI(.movie, .week).endpoint
    }
    
    private func testCall3() {
        let upcoming = EndpointStorage.upcomingAPI(.movie)
    }
    
    private func testCall4() {
        
    }
}