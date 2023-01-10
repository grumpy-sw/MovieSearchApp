//
//  RealmMoviePagesStorage.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2023/01/11.
//

import Foundation
import RealmSwift

final class RealmMoviePagesStorage {
    private let realmStorage: RealmStorage
    
    init(realmStorage: RealmStorage) {
        self.realmStorage = realmStorage
    }
}

extension RealmMoviePagesStorage: MoviePagesStorage {
    func createFavorite(moviePage: MoviePageRMO, completion: @escaping (Result<Void, RealmStorageError>) -> Void) {
        do {
            try realmStorage.create(moviePage: moviePage)
            completion(.success(()))
        } catch {
            completion(.failure(.createError))
        }
    }
    
    func deleteFavorite(moviePage: MoviePageRMO, completion: @escaping (Result<Void, RealmStorageError>) -> Void) {
        do {
            try realmStorage.delete(moviePage: moviePage)
            completion(.success(()))
        } catch {
            completion(.failure(.deleteError))
        }
    }
    
    func fetchAllFavorites() -> MovieCollection {
        return MovieCollection(movies: realmStorage.fetchAll().map{ $0.toDomain() })
    }
    
    func fetchFavorite(moviePage: MoviePageRMO, completion: @escaping (Result<MoviePage, RealmStorageError>) -> Void) {
        guard let result = realmStorage.fetchMovie(moviePage: moviePage).first else {
            completion(.failure(.fetchError))
            return
        }
        completion(.success(result.toDomain()))
    }
}
