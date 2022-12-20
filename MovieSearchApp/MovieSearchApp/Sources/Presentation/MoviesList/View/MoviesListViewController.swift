//
//  MoviesListViewController.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/20.
//

import UIKit

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
    
    private lazy var searchBar = UISearchBar().then {
        $0.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.size.width * 0.8, height: 0)
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        searchBar.text = query
        navigationItem.rightBarButtonItem = cancelSearchButton
        
        configureDataSource()
        viewModel.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.coordinator?.dismissMoviesListViewController(self)
    }
    
    @objc func showSearchBar() {
        title = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = cancelSearchButton
        print(searchBar.bounds.width)
    }
    
    @objc func hideSearchBar() {
        self.navigationItem.leftBarButtonItem = nil
        title = query
        self.navigationItem.rightBarButtonItem = searchIconButton
    }
}

extension MoviesListViewController {
    private func configureDataSource() {
//
//        // MARK: - Cell Registration
//        let cellRegistration = UICollectionView.CellRegistration<MoviesListItemCell, Movie> { (cell, indexPath, movie) in
//            cell.updateCell(with: movie)
//
//            cell.accessories = [.disclosureIndicator()]
//        }
//
//        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: moviesListView.collectionView) {
//            (collectionView: UICollectionView, indexPath: IndexPath, item: Movie) -> UICollectionViewCell? in
//            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
//        }
//
//        // initial data
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(Item.all)
//        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
