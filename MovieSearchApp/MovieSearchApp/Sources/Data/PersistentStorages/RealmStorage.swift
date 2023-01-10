//
//  RealmStorage.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2023/01/11.
//

import Foundation
import RealmSwift

enum RealmStorageError: LocalizedError {
    case createError
    case deleteError
    case fetchError
    
    var errorDescription: String {
        switch self {
        case .createError:
            return "Failed to Save to Local Storage."
        case .deleteError:
            return "Failed to Delete from Local Storage."
        case .fetchError:
            return "Failed to Load from Local Storage"
        }
    }
}

struct RealmStorage {
    private let realmInstance = try? Realm()
    
    func create(moviePage: MoviePageRMO) throws {
        do {
            try realmInstance?.write {
                realmInstance?.add(moviePage)
            }
        } catch {
            throw RealmStorageError.createError
        }
    }
    
    func delete(moviePage: MoviePageRMO) throws {
        do {
            try realmInstance?.write {
                let object = realmInstance?.objects(MoviePageRMO.self).where {
                    $0.id == moviePage.id
                }
                guard let object = object else { return }
                if let queriedPage = object.filter({ $0 == $0 }).first {
                    realmInstance?.delete(queriedPage)
                }
            }
        } catch {
            throw RealmStorageError.deleteError
        }
    }
    
    func fetchMovie(moviePage: MoviePageRMO) -> [MoviePageRMO] {
        let object = realmInstance?.objects(MoviePageRMO.self).where {
            $0.id == moviePage.id
        }
        guard let object = object else { return [] }
        return object.filter { $0 == $0 }
    }
    
    func fetchAll() -> [MoviePageRMO] {
        guard let result = realmInstance?.objects(MoviePageRMO.self) else { return [] }
        return Array(result)
    }
}
