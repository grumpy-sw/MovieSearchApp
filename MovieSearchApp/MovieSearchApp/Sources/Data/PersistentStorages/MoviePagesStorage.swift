//
//  MoviePagesStorage.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2023/01/11.
//

import Foundation

protocol MoviePagesStorage {
    func createFavorite(moviePage: MoviePageRMO, completion: @escaping (Result<Void, RealmStorageError>) -> Void)
    func deleteFavorite(moviePage: MoviePageRMO, completion: @escaping (Result<Void, RealmStorageError>) -> Void)
    func fetchAllFavorites() -> MovieCollection
    func fetchFavorite(moviePage: MoviePageRMO, completion: @escaping (Result<MoviePage, RealmStorageError>) -> Void)
}
