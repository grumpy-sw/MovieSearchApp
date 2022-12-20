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

final class MoviesListViewController: UIViewController {
    
    private let moviesListView = MoviesListView()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>! = nil
    override func loadView() {
        self.view = moviesListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
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
